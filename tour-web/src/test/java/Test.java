import cn.edu.hlju.tour.dao.PathMapper;
import cn.edu.hlju.tour.entity.Path;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Sole on 2017/3/31.
 */
public class Test {

    @org.junit.Test
    public void test() {
        ApplicationContext context = new ClassPathXmlApplicationContext("classpath:spring/spring-application.xml");

        // 从spring容器中获取mapper代理对象
        PathMapper pathMapper = context.getBean(PathMapper.class);

        List<Path> list = new ArrayList<>();
        list.add(new Path(10L, 11L, "1"));
        list.add(new Path(10L, 12L, "1"));
        list.add(new Path(10L, 13L, "-1"));

        pathMapper.insertBatch(list);

    }

}
