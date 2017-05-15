package cn.edu.hlju.tour.web.controller;

import cn.edu.hlju.tour.core.SpotService;
import cn.edu.hlju.tour.entity.Spot;
import cn.edu.hlju.tour.entity.SpotComment;
import com.alibaba.fastjson.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * Created by Sole on 2017/3/31.
 */
@Controller
public class SpotController {

    @Autowired
    private SpotService spotService;

    @RequestMapping(value = "haveSpot")
    @ResponseBody
    public String haveSpot(String spotName) {
        return spotService.haveSpot(spotName);
    }

    @RequestMapping(value = "spotByName")
    public String getSpot(String spotName, HttpServletRequest request) {
        JSONObject json = spotService.spotByName(spotName);
        request.setAttribute("json", json);
        return "forward:destination.jsp";
    }

    @RequestMapping(value = "spot")
    public String getSpot(Long id, HttpServletRequest request) {
        JSONObject json = spotService.spotById(id);
        request.setAttribute("json", json);
        return "forward:destination.jsp";
    }

    //评论分页
    @RequestMapping(value = "spotComment")
    @ResponseBody
    public JSONObject spotComment(HttpServletRequest request) {
        String spotId = request.getParameter("spotId");
        String pageNum = request.getParameter("pageNum");
        String size = request.getParameter("size");
        Long id = Long.parseLong(spotId);
        return spotService.getSpotComment(id, Integer.parseInt(pageNum), Integer.parseInt(size));
    }

    @RequestMapping(value = "spots")
    public String spots(HttpServletRequest request) {
        List<Spot> list = spotService.getAllSpot();
        request.setAttribute("spotlist", list);
        return "forward:spots.jsp";
    }

    @RequestMapping(value = "addSpotComment")
    @ResponseBody
    public void saveComment(SpotComment comment, HttpServletRequest request) {
        spotService.saveComment(comment, request);
    }

    @RequestMapping(value= "getAllSpot")
    @ResponseBody
    public List getAllSpot() {
        List<Spot> list = spotService.getAllSpot();
        return list;
    }

}
