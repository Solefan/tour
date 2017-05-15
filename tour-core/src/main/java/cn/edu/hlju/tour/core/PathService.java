package cn.edu.hlju.tour.core;

import cn.edu.hlju.tour.entity.Path;
import com.alibaba.fastjson.JSONObject;

/**
 * Created by lft on 2017/5/14.
 */
public interface PathService {

    JSONObject selectPathByPage(int pageNum, int size, Path path);

    void update(Path path);

}
