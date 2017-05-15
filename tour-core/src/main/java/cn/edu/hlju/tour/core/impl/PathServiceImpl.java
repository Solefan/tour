package cn.edu.hlju.tour.core.impl;

import cn.edu.hlju.tour.core.PathService;
import cn.edu.hlju.tour.dao.PathMapper;
import cn.edu.hlju.tour.entity.Path;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by lft on 2017/5/14.
 */
@Service
public class PathServiceImpl implements PathService {

    @Autowired
    private PathMapper pathMapper;

    @Override
    public JSONObject selectPathByPage(int pageNum, int size, Path path) {
        PageHelper.startPage(pageNum, size);                        //分页
        List<Path> list = pathMapper.selectByPath(path);            //得到分页之后的用户
        PageInfo<Path> pageInfo = new PageInfo(list);               //分页参数
        JSONObject json = new JSONObject();
        json.put("pageinfo", pageInfo);
        json.put("list", list);
        return json;
    }

    @Override
    public void update(Path path) {
        pathMapper.updateByPrimaryKeySelective(path);
    }

}
