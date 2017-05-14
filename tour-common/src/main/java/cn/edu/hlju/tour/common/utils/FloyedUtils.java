package cn.edu.hlju.tour.common.utils;

/**
 * Created by lft on 2017/5/13.
 */
public class FloyedUtils {

//    public static void floyd(int[][] path, int[][] dist) {
//
//        // 初始化
//        for (int i = 0; i < mVexs.length; i++) {
//            for (int j = 0; j < mVexs.length; j++) {
//                dist[i][j] = mMatrix[i][j];    // "顶点i"到"顶点j"的路径长度为"i到j的权值"。
//                if (0 < dist[i][j] && dist[i][j] < INF) {
//                    path[i][j] = i;
//                } else {
//                    path[i][j] = -1;
//                }
//            }
//        }
//
//        // 计算最短路径
//        for (int k = 0; k < mVexs.length; k++) {
//            for (int i = 0; i < mVexs.length; i++) {
//                for (int j = 0; j < mVexs.length; j++) {
//
//                    // 如果经过下标为k顶点路径比原两点间路径更短，则更新dist[i][j]和path[i][j]
//                    int tmp = (dist[i][k]==INF || dist[k][j]==INF) ? INF : (dist[i][k] + dist[k][j]);
//                    if (tmp < dist[i][j]) {
//                        // "i到j最短路径"对应的值设，为更小的一个(即经过k)
//                        dist[i][j] = tmp;
//                        // "i到j最短路径"对应的路径，经过k
//                        path[i][j] = path[k][j];
//                    }
//                }
//            }
//        }
//
//        // 打印floyd最短路径的结果
//        System.out.printf("floyd: \n");
//        for (int i = 0; i < mVexs.length; i++) {
//            for (int j = 0; j < mVexs.length; j++)
//                System.out.printf("%2d  ", dist[i][j]);
//            System.out.printf("\n");
//        }
//
//        // 打印floyd最短路径的结果
//        System.out.printf("path: \n");
//        for (int i = 0; i < mVexs.length; i++) {
//            for (int j = 0; j < mVexs.length; j++)
//                System.out.printf("%2d  ", path[i][j]);
//            System.out.printf("\n");
//        }
//
//    }


}