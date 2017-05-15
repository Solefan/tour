package cn.edu.hlju.tour.web.controller;

import cn.edu.hlju.tour.core.PathService;
import cn.edu.hlju.tour.entity.Path;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * Created by lft on 2017/5/15.
 */
@Controller
public class PathController {

    @Autowired
    private PathService pathService;

    @RequestMapping(value= "getPathList")
    @ResponseBody
    public String getPathList(int page, int rows, Path path) {

        //{"total":10, "row":[{},{}]}
        JSONObject json = pathService.selectPathByPage(page, rows, path);
        PageInfo pageInfo = (PageInfo)json.get("pageinfo");
        List<Path> list = (List)json.get("list");
        long total = pageInfo.getTotal();
        String str = JSON.toJSONString(list);
        String jsonStr = "{\"total\":" + total + ", \"rows\":" + str + "}";
        return jsonStr;

    }

    /**
     *
     * @param path
     * @param type 是否直达 0:不直达
     */
    @RequestMapping(value= "editPath")
    @ResponseBody
    public void editPath(Path path, int type) {
        if (type == 0) {
            path.setDistance("-1");
        }
        pathService.update(path);
    }

}
