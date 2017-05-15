package cn.edu.hlju.tour.web.controller;

import cn.edu.hlju.tour.core.PathService;
import cn.edu.hlju.tour.core.utils.GraphInit;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * Created by lft on 2017/5/14.
 */
@Controller
public class PathController {

    @Autowired
    private GraphInit graphInit;

    @Autowired
    private PathService pathService;


    @RequestMapping(value = "path")
    @ResponseBody
    public List path(Long fromSid, Long toSid) {
        graphInit.initGraph();
        return graphInit.getPath(fromSid, toSid);
    }

}
