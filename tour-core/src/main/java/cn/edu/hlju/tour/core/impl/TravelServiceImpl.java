package cn.edu.hlju.tour.core.impl;

import cn.edu.hlju.tour.common.utils.RandomUtils;
import cn.edu.hlju.tour.common.utils.UploadUtils;
import cn.edu.hlju.tour.core.TravelService;
import cn.edu.hlju.tour.dao.*;
import cn.edu.hlju.tour.entity.*;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.*;

/**
 * Created by lft on 2017/3/24.
 */
@Service
public class TravelServiceImpl implements TravelService {

    @Autowired
    private TravelMapper travelMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private SpotMapper spotMapper;

    @Autowired
    private TravelCommentMapper travelCommentMapper;

    @Autowired
    private MessageMapper messageMapper;


    //得到五个游记
    @Override
    public List<Map> limit5() {
        Long total = travelMapper.total();
        Set<Long> set = null;
        if (total < 5) {
            set = RandomUtils.randomSet(total, total);
        } else {
            set = RandomUtils.randomSet(total, 5L);
        }
        List<Map> list = new ArrayList<>();
        Iterator<Long> iterator = set.iterator();
        while (iterator.hasNext()) {
            Travel travel = travelMapper.selectLimitOne(iterator.next());       //游记
            Long spotid = travel.getSpotId();
            Spot spot = spotMapper.selectByPrimaryKey(spotid);                  //游记的地点
            Long userid = travel.getUserId();
            User user = userMapper.selectByPrimaryKey(userid);                  //写游记的用户
            Map<String, Object> map = new HashMap<>();
            map.put("travel", travel);
            map.put("user", user);
            map.put("spot", spot);
            list.add(map);
        }
        return list;
    }

    /**
     * 保存并返回刚保存游记的ID
     * @param travel
     * @param request
     * @return
     */
    @Override
    public Long saveTravel(Travel travel, HttpServletRequest request) {
        User user = (User)request.getSession().getAttribute("user");
        travel.setUserId(user.getId());
        travel.setTime(new Date());
        travel.setStatus(0L);
        travelMapper.insertSelective(travel);
        return travel.getId();
    }

    @Override
    public void delTravel(Long id) {
        travelMapper.deleteByPrimaryKey(id);
    }

    /**
     * 得到游记页面需要的东西
     * @param id
     * @param request
     */
    @Override
    public JSONObject travelById(Long id) {
        JSONObject json = new JSONObject();
        Travel travel = travelMapper.selectByPrimaryKey(id);
        User user = userMapper.selectByPrimaryKey(travel.getUserId());
        Long spotid = travel.getSpotId();
        List<Travel> list = this.limit3BySpotId(spotid);        //相关的三个游记
        json.put("travel", travel);                              //游记
        json.put("user", user);                                  //写该游记的用户
        json.put("list", list);                                  //相关游记
        return json;
    }

    //推荐的相同地点的三个游记
    private List<Travel> limit3BySpotId(Long id) {
        Long total = travelMapper.totalBySpotId(id);
        Set<Long> set = null;
        if (total < 3) {
            set = RandomUtils.randomSet(total, total);
        } else {
            set = RandomUtils.randomSet(total, 3L);
        }
        List<Travel> list = new ArrayList<>();
        Iterator<Long> iterator = set.iterator();
        while (iterator.hasNext()) {
            list.add(travelMapper.selectBySpotIdLimitOne(iterator.next(), id));
        }
        return list;
    }

    /**
     * 上传游记头部图片
     * @param file
     * @param request
     * @return
     * @throws IOException
     */
    @Override
    public Map uploadIndexImg(MultipartFile file, HttpServletRequest request) throws IOException {
        String contextPath = UploadUtils.uploadFile(file, request, "travel/indeximg/");
        Map<String, String> map = new HashMap<>();
        map.put("src", contextPath);
        return map;
    }

    /**
     * 上传游记图片
     * @param file
     * @param request
     * @return
     * @throws IOException
     */
    @Override
    public Map uploadTravelImg(MultipartFile file, HttpServletRequest request) throws IOException {
        User user = (User)request.getSession().getAttribute("user");
        String email = user.getEmail();
        String contextPath = UploadUtils.uploadFile(file, request, "travel/" + email + "/");
        Map<String, String> map = new HashMap<>();
        map.put("src", contextPath);
        return map;
    }


    /**
     * 分页查询
     * @param spotName 景点名字
     */
    @Override
    public JSONObject queryByPage(String spotName, int pageNum, int size) {
        JSONObject json = new JSONObject();
        Travel travel = new Travel();
        if (spotName == null || "".equals(spotName)) {              //无条件查询
        } else {
            Spot spot = spotMapper.selectBySpotName(spotName);      //条件查询
            if (spot == null) {
                json.put("status", "spotNotExist");
                return json;
            }
            travel.setStatus(1L);
            travel.setSpotId(spot.getId());
        }
        PageHelper.startPage(pageNum, size);
        List<Travel> list =  travelMapper.query(travel);
        if (list == null || list.size() == 0) {
            json.put("status", "travelNotExist");
            return json;
        }
        PageInfo<Travel> pageInfo = new PageInfo(list);
        List<Map> mapList = new ArrayList<>();
        for (Travel temp : list) {
            Long spotid = temp.getSpotId();
            Spot spot = spotMapper.selectByPrimaryKey(spotid);                  //游记的地点
            Long userid = temp.getUserId();
            User user = userMapper.selectByPrimaryKey(userid);                  //写游记的用户
            Map<String, Object> map = new HashMap<>();
            map.put("travel", temp);
            map.put("user", user);
            map.put("spot", spot);
            mapList.add(map);
        }
        json.put("status", "success");
        json.put("pageinfor", pageInfo);
        json.put("maplist", mapList);
        return json;
    }

    /**
     *
     * @param id 用户ID
     * @return
     */
    @Override
    public List queryByUserId(Long id) {
        Travel travel = new Travel();
        travel.setUserId(id);
        return travelMapper.query(travel);
    }

    @Override
    public JSONObject getTravelComment(Long id, int pageNum, int size) {
        PageHelper.startPage(pageNum, size);                                                //分页
        List<TravelComment> list =  travelCommentMapper.selectCommentByTravelId(id);        //得到分页之后的评论
        PageInfo<TravelComment> pageInfo = new PageInfo(list);                              //分页参数
        List<Map> mapList = new ArrayList<>();
        for (TravelComment comment : list) {                                                //评论用户
            Map map = new HashMap();
            Long userId = comment.getUserId();
            Long applyCid = comment.getApplyCid();
            User user = userMapper.selectByPrimaryKey(userId);
            if (applyCid != null) {
                TravelComment applyComment = travelCommentMapper.selectByPrimaryKey(applyCid);
                Long applyUserId = applyComment.getUserId();
                User applyUser = userMapper.selectByPrimaryKey(applyUserId);
                map.put("applyUser", applyUser);
                map.put("applyComment", applyComment);
            }
            map.put("comment", comment);
            map.put("user", user);
            mapList.add(map);
        }
        JSONObject json = new JSONObject();
        json.put("pageinfor", pageInfo);
        json.put("maplist", mapList);
        return json;
    }

    /**
     * 发表评论
     * @param comment
     * @param request
     */
    @Override
    @Transactional
    public void saveComment(TravelComment comment, HttpServletRequest request) {
        Date date = new Date();
        User user = (User)request.getSession().getAttribute("user");            //获取当前用户
        comment.setUserId(user.getId());
        comment.setTime(date);
        Message message = new Message();                                        //建立message对象
        message.setFromUid(user.getId());
        message.setStatus(0L);
        message.setTime(date);
        message.setType(0L);

        Travel travel = travelMapper.selectByPrimaryKey(comment.getTravelId()); //获得游记实体
        String content = "";

        if (comment.getApplyCid() == null) {                                    //判断该评论是回复还是直接评论
            message.setToUid(travel.getUserId());
            content = "评论了你的游记 <a href='/tour/travel?id=" + travel.getId() + "'>" + travel.getTitle() + "</a><br/>";
        } else {
            message.setToUid(travelCommentMapper.selectByPrimaryKey(comment.getApplyCid()).getUserId());
            content = "回复了你在游记 <a href='/tour/travel?id=" + travel.getId() + "'>" + travel.getTitle() + "</a> 中的评论<br/>";
        }

        content += comment.getContent();
        message.setContent(content);
        messageMapper.insertSelective(message); //添加消息
        travelCommentMapper.insertSelective(comment);//发表评论
    }

    @Override
    public void delComment(Long id) {
        travelCommentMapper.deleteByPrimaryKey(id);
    }

    @Override
    public JSONObject selectNotAuditTravelByPage(int pageNum, int size, Travel travel) {
        travel.setStatus(0L);
        PageHelper.startPage(pageNum, size);                     //分页
        List<Travel> list = travelMapper.query(travel);          //得到分页之后的游记 0表示未审核
        PageInfo<Travel> pageInfo = new PageInfo(list);          //分页参数
        JSONObject json = new JSONObject();
        json.put("pageinfo", pageInfo);
        json.put("list", list);
        return json;
    }

    /**
     * 审核
     * @param type
     * @param opinion
     * @param travel
     */
    @Override
    public void audit(String type, String opinion, Travel travel, HttpServletRequest request) {
        StringBuilder content = new StringBuilder();        //消息内容
        if ("pass".equals(type)) {
            travel.setStatus(1L);
            content.append("恭喜，您的游记  <a href='/tour/travel?id=").append(travel.getId()).append("'>").append(travel.getTitle()).append("</a> 通过了审核<br/>");
        } else {
            travel.setStatus(2L);
            content.append("抱歉，您的游记  <a href='/tour/travel?id=").append(travel.getId()).append("'>").append(travel.getTitle()).append("</a> 没有通过审核<br/>");
        }
        content.append("审核意见：" + opinion);
        travelMapper.updateByPrimaryKeySelective(travel);
        //发送消息
        User user = (User)request.getSession().getAttribute("user");
        Message message = new Message();
        message.setFromUid(user.getId());
        message.setToUid(travel.getUserId());
        message.setStatus(0L);
        message.setTime(new Date());
        message.setType(1L);
        message.setContent(content.toString());
        messageMapper.insertSelective(message);
    }

}
