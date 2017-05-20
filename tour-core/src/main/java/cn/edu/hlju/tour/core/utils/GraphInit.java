package cn.edu.hlju.tour.core.utils;

import cn.edu.hlju.tour.dao.PathMapper;
import cn.edu.hlju.tour.dao.SpotMapper;
import cn.edu.hlju.tour.entity.Path;
import cn.edu.hlju.tour.entity.Spot;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.*;

/**
 * Created by lft on 2017/5/14.
 */
@Component
public class GraphInit {

    private static Graph GRAPH = new Graph();
    private static int[][] PATH;    //前驱
    private static int[][] DIST;    //路径距离
    private static Map<Long, Integer> MAP = new HashMap<>();

    @Autowired
    private PathMapper pathMapper;

    @Autowired
    private SpotMapper spotMapper;

    /**
     * 将数据库中的路径数据导入初始化图并求出最短路径
     */
    public void initGraph() {

        List<Path> list = pathMapper.selectAll();
        Set<Long> set = new TreeSet<>();
        for (Path path : list) {
            set.add(path.getFromSid());
            set.add(path.getToSid());
        }
        //顶点集合
        Long[] vexs = new Long[set.size()];
        set.toArray(vexs);

        for (int i = 0; i<vexs.length; i++) {
            MAP.put(vexs[i], i);
        }

        GRAPH.setVexs(vexs);

        int[][] matrix = new int[vexs.length][vexs.length];
        for (Path path : list) {
            Long fromSid = path.getFromSid();
            Long toSid = path.getToSid();
            if (path.getDistance().equals("-1")) {
                matrix[MAP.get(fromSid)][MAP.get(toSid)] = Graph.INF;
            } else {
                matrix[MAP.get(fromSid)][MAP.get(toSid)] = Integer.parseInt(path.getDistance());
            }
        }

        GRAPH.setMatrix(matrix);

        floyd(GRAPH);
    }

    /**
     * floyd最短路径。
     * 即，统计图中各个顶点间的最短路径。
     *
     * 参数说明：
     *     PATH -- 路径。path[i][j]=k表示，"顶点i"到"顶点j"的最短路径会经过顶点k。
     *     DIST -- 长度数组。即，dist[i][j]=sum表示，"顶点i"到"顶点j"的最短路径的长度是sum。
     */
    private void floyd(Graph graph) {

        Long[] vexs = graph.getVexs();
        int[][] matrix = graph.getMatrix();
        int len = vexs.length;

        PATH = new int[len][len];
        DIST = new int[len][len];

        // 初始化
        for (int i = 0; i < len; i++) {
            for (int j = 0; j < len; j++) {
                DIST[i][j] = matrix[i][j];          // "顶点i"到"顶点j"的路径长度为"i到j的权值"。
                if (0 < DIST[i][j] && DIST[i][j] < Graph.INF) {
                    PATH[i][j] = i;
                } else {
                    PATH[i][j] = -1;
                }
            }
        }

        // 计算最短路径
        for (int k = 0; k < len; k++) {
            for (int i = 0; i < len; i++) {
                for (int j = 0; j < len; j++) {
                    // 如果经过下标为k顶点路径比原两点间路径更短，则更新dist[i][j]和path[i][j]
                    int tmp = (DIST[i][k]==Graph.INF || DIST[k][j]==Graph.INF) ? Graph.INF : (DIST[i][k] + DIST[k][j]);
                    if (tmp < DIST[i][j]) {
                        // "i到j最短路径"对应的值设，为更小的一个(即经过k)
                        DIST[i][j] = tmp;
                        // "i到j最短路径"对应的路径，经过k
                        PATH[i][j] = PATH[k][j];
                    }
                }
            }
        }

        // 打印floyd最短路径的结果
        System.out.printf("floyd: \n");
        for (int i = 0; i < len; i++) {
            for (int j = 0; j < len; j++)
                System.out.printf("%2d  ", DIST[i][j]);
            System.out.printf("\n");
        }

        // 打印PATH
        System.out.printf("path: \n");
        for (int i = 0; i < len; i++) {
            for (int j = 0; j < len; j++)
                System.out.printf("%2d  ", PATH[i][j]);
            System.out.printf("\n");
        }

    }
//获取景点路径
    public List<Spot> getPath(Long fromSid, Long toSid) {

        List<Spot> list = new ArrayList<>();      //存经过的各个景点

        int start = MAP.get(fromSid);
        int end = MAP.get(toSid);

        //起点和终点在一起或者不可达时，返回
        if (PATH[start][end] == -1) {
            if (start == end) {
                System.out.println("起点和终点在一起");
            } else {
                System.out.println("两点不可达");
            }
            return list;
        }

        List<Integer> listTemp = new ArrayList<>();
        listTemp.add(end);
        while (PATH[start][end] != start) {
            end = PATH[start][end];
            listTemp.add(end);
        }
        listTemp.add(start);

        Long[] vexs = GRAPH.getVexs();
        for (int i = listTemp.size()-1; i>=0; i--) {
            Spot spot = spotMapper.selectByPrimaryKey(vexs[listTemp.get(i)]);
            list.add(spot);
        }
        return list;
    }

}
