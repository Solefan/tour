import cn.edu.hlju.tour.core.utils.GraphInit;
import cn.edu.hlju.tour.entity.Spot;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.List;

/**
 * Created by Sole on 2017/3/31.
 */
public class Test {

    @org.junit.Test
    public void test() {
        ApplicationContext context = new ClassPathXmlApplicationContext("classpath:spring/spring-application.xml");
        // 从spring容器中获取mapper代理对象
        GraphInit graphInit = context.getBean(GraphInit.class);

        List<Spot> list = graphInit.getPath(2L, 3L);

        for (Spot s : list) {
            System.out.println(s);
        }
    }

}
