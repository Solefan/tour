package cn.edu.hlju.tour.core.impl;

import cn.edu.hlju.tour.common.utils.UploadUtils;
import cn.edu.hlju.tour.core.SpotService;
import cn.edu.hlju.tour.dao.*;
import cn.edu.hlju.tour.entity.Path;
import cn.edu.hlju.tour.entity.Spot;
import cn.edu.hlju.tour.entity.SpotComment;
import cn.edu.hlju.tour.entity.User;
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
 * Created by Sole on 2017/3/31.
 */
@Service
public class SpotServiceImpl implements SpotService {

    @Autowired
    private SpotMapper spotMapper;

    @Autowired
    private SpotCommentMapper spotCommentMapper;

    @Autowired
    private PathMapper pathMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private SpotImgMapper spotImgMapper;

    private JSONObject jsonTemp;    //暂存ajax查询是否有该景点时缓存得到

    @Override
    public String haveSpot(String spotName) {
        JSONObject json = new JSONObject();
        Spot spot = spotMapper.selectBySpotName(spotName);
        if (spot == null) {
            return "spotNotExist";
        }
        Long id = spot.getId();
        json.put("spot", spot);
        json.put("spotImg", spotImgMapper.selectBySpotId(id));
        jsonTemp = json;
        return "success";
    }

    @Override
    public JSONObject spotByName(String spotName) {
        if (jsonTemp == null) {
            this.haveSpot(spotName);
        }
        return jsonTemp;
    }

    @Override
    public JSONObject spotById(Long id) {
        JSONObject json = new JSONObject();
        Spot spot = spotMapper.selectByPrimaryKey(id);
        json.put("spot", spot);
        json.put("spotImg", spotImgMapper.selectBySpotId(id));
        return json;
    }

    /**
     *
     * @param id 景点ID
     * @param pageNum 第几页
     * @param size  每页的大小
     * @return
     */
    @Override
    public JSONObject getSpotComment(Long id, int pageNum, int size) {
        PageHelper.startPage(pageNum, size);                                        //分页
        List<SpotComment> list =  spotCommentMapper.selectCommentBySpotId(id);      //得到分页之后的评论
        PageInfo<SpotComment> pageInfo = new PageInfo(list);                        //分页参数
        List<Map> mapList = new ArrayList<>();
        for (SpotComment comment : list) {                                          //评论用户
            Map map = new HashMap();
            Long userId = comment.getUserId();
            User user = userMapper.selectByPrimaryKey(userId);
            map.put("comment", comment);
            map.put("user", user);
            mapList.add(map);
        }
        JSONObject json = new JSONObject();
        json.put("pageinfor", pageInfo);
        json.put("maplist", mapList);
        return json;
    }

    @Override
    public List<Spot> getAllSpot() {
        return spotMapper.selectAll();
    }

    @Override
    public void saveComment(SpotComment comment, HttpServletRequest request) {
        User user = (User)request.getSession().getAttribute("user");
        comment.setUserId(user.getId());
        comment.setTime(new Date());
        spotCommentMapper.insertSelective(comment);
    }

    @Override
    public JSONObject selectSpotByPage(int pageNum, int size, Spot spot) {
        PageHelper.startPage(pageNum, size);                        //分页
        List<Spot> list = spotMapper.selectBySpot(spot);            //得到分页之后的用户
        PageInfo<Spot> pageInfo = new PageInfo(list);               //分页参数
        JSONObject json = new JSONObject();
        json.put("pageinfo", pageInfo);
        json.put("list", list);
        return json;
    }

    @Override
    public void update(Spot spot) {
        spotMapper.updateByPrimaryKeySelective(spot);
    }

    @Override
    @Transactional
    public void delSpot(Long[] ids) {
        //删除景点评论
        spotCommentMapper.delBySpotId(ids);

        //删除景点图片
        spotImgMapper.delBySpotId(ids);

        //删除景点
        spotMapper.delBySpotId(ids);

        //删除路径
        pathMapper.delBySpotId(ids);

    }

    @Override
    @Transactional
    public void addSpot(Spot spot) {
        List<Spot> list = this.getAllSpot();
        //添加景点
        int spotId = spotMapper.insertSelective(spot);

        if (list.size() != 0) {
            //添加路径， 初始化都不可直达
            List<Path> listPath = new ArrayList<>();
            for (Spot s : list) {
                listPath.add(new Path(new Long(spotId), s.getId(), "-1"));
                listPath.add(new Path(s.getId(), new Long(spotId), "-1"));
            }
            pathMapper.insertBatch(listPath);
        }

    }

    /**
     * 上传景点宣传图片
     * @param file
     * @param request
     * @return
     * @throws IOException
     */
    @Override
    public String uploadIndexImg(MultipartFile file, HttpServletRequest request) throws IOException {
        String contextPath = UploadUtils.uploadFile(file, request, "spot/indeximg/");
        return contextPath;
    }

}
