package cn.edu.hlju.tour.core;

import cn.edu.hlju.tour.entity.Spot;
import cn.edu.hlju.tour.entity.SpotComment;
import com.alibaba.fastjson.JSONObject;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

/**
 * Created by Sole on 2017/3/31.
 */
public interface SpotService {

    String haveSpot(String spotName);

    JSONObject spotByName(String spotName);

    JSONObject spotById(Long id);

    JSONObject getSpotComment(Long id, int pageNum, int size);

    List<Spot> getAllSpot();

    void saveComment(SpotComment comment, HttpServletRequest request);

    JSONObject selectSpotByPage(int page, int rows, Spot spot);

    void update(Spot spot);

    void delSpot(Long[] ids);

    void addSpot(Spot spot);

    String uploadIndexImg(MultipartFile file, HttpServletRequest request) throws IOException;
}
