package cn.edu.hlju.tour.web.controller;

import cn.edu.hlju.tour.core.TravelService;
import cn.edu.hlju.tour.entity.Travel;
import cn.edu.hlju.tour.entity.TravelComment;
import cn.edu.hlju.tour.entity.User;
import com.alibaba.fastjson.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;
import java.util.Map;


@Controller
public class TravelController {

    @Autowired
    private TravelService travelService;

    /**
     * 首页查询三条随机攻略
     *
     * @return
     */
    @RequestMapping(value = "limit5")
    @ResponseBody
    public List limit5() {
        List<Map> list = travelService.limit5();
        return list;
    }

    /**
     * 换一批
     *
     * @return
     */
    @RequestMapping(value = "refresh")
    @ResponseBody
    public List refresh() {
        return limit5();
    }

    /**
     * 查询攻略进去攻略页面
     *
     * @param id      攻略ID
     * @param request
     * @return
     */
    @RequestMapping(value = "travel")
    public String travel(Long id, HttpServletRequest request) {
        JSONObject json = travelService.travelById(id);
        request.setAttribute("json", json);
        return "forward:travel.jsp";
    }


    @RequestMapping(value = "uploadindeximg")
    @ResponseBody
    public Object uploadIndexImg(@RequestParam("file") MultipartFile file, HttpServletRequest request) throws IOException {
        Map map = travelService.uploadIndexImg(file, request);
        return map;
    }

    @RequestMapping(value = "uploadtravelimg")
    @ResponseBody
    public Object uploadTravelImg(@RequestParam("file") MultipartFile file, HttpServletRequest request) throws IOException {
        Map map = travelService.uploadTravelImg(file, request);
        return map;
    }

    @RequestMapping(value = "savetravel")
    public String saveTravel(Travel travel, HttpServletRequest request) {
        Long id = travelService.saveTravel(travel, request);
        request.setAttribute("travelid", id);
        return "forward:check.jsp";
    }

    @RequestMapping(value = "deltravel")
    @ResponseBody
    public void delTravel(Long id) throws IOException {
        travelService.delTravel(id);
    }

    /**
     * 游记分页
     *
     * @param travel  查询条件
     * @param request
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "travels")
    @ResponseBody
    public JSONObject travels(HttpServletRequest request) throws IOException {
        String spotName = request.getParameter("spotname");
        String pageNum = request.getParameter("pageNum");
        String size = request.getParameter("size");
        return travelService.queryByPage(spotName, Integer.parseInt(pageNum), Integer.parseInt(size));
    }

    @RequestMapping(value = "mytravels")
    @ResponseBody
    public List queryMyTravel(HttpServletRequest request) {
        User user = (User) request.getSession().getAttribute("user");
        return travelService.queryByUserId(user.getId());
    }

    /**
     * 评论分页
     */
    @RequestMapping(value = "travelComment")
    @ResponseBody
    public JSONObject travelComment(HttpServletRequest request) {
        String spotId = request.getParameter("travelId");
        String pageNum = request.getParameter("pageNum");
        String size = request.getParameter("size");
        Long id = Long.parseLong(spotId);
        return travelService.getTravelComment(id, Integer.parseInt(pageNum), Integer.parseInt(size));
    }

    /**
     * 添加评论
     */
    @RequestMapping(value = "addTravelComment")
    @ResponseBody
    public void saveComment(TravelComment comment, HttpServletRequest request) {
        travelService.saveComment(comment, request);
    }
    /**
     * 删除评论
     */
    @RequestMapping(value = "delTravelComment")
    @ResponseBody
    public void delComment(Long id) {
        travelService.delComment(id);
    }


}
