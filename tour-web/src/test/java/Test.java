import cn.edu.hlju.tour.core.SpotService;
import cn.edu.hlju.tour.entity.Spot;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Created by Sole on 2017/3/31.
 */
public class Test {

    @org.junit.Test
    public void test() {
        ApplicationContext context = new ClassPathXmlApplicationContext("classpath:spring/spring-application.xml");

        // 从spring容器中获取mapper代理对象
        SpotService s = context.getBean(SpotService.class);

        Spot spot = new Spot();
        spot.setIndexImg("");
        spot.setCoordinate("");
        spot.setLocation("");
        spot.setOpenTime("");
        spot.setTraffic("");
        spot.setSpendTime("");
        spot.setSpotIntroduce("");
        spot.setSpotName("");
        spot.setTicket("");

        s.addSpot(spot);


    }

}
