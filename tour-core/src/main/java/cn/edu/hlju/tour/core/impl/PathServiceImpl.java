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
        //更新第一条路径
        pathMapper.updateByPrimaryKeySelective(path);

        //更新第二条路径
        // 1. 根据from and to  查出另一条路线
        // 2. 获取该路线并更新路径长度
        Path pathTemp = new Path();
        pathTemp.setFromSid(path.getToSid());
        pathTemp.setToSid(path.getFromSid());
        List<Path> list = pathMapper.selectByPath(pathTemp);
        pathTemp = list.get(0);
        pathTemp.setDistance(path.getDistance());
        pathMapper.updateByPrimaryKeySelective(pathTemp);

    }

}
