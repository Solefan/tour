package cn.edu.hlju.tour.common.utils;

import java.util.ArrayList;
import java.util.List;

/**
 * Java: Floyd算法获取最短路径(邻接矩阵)
 *
 * @author lft
 * @date 2017/04/25
 */
public class MatrixUDG {

    private String[] mVexs;       // 顶点集合
    private int[][] mMatrix;    // 邻接矩阵
    private static final int INF = Integer.MAX_VALUE;   // 最大值

    /*
     * 创建图(用已提供的矩阵)
     *
     * 参数说明：
     *     vexs  -- 顶点数组
     *     matrix-- 矩阵(数据)
     */
    public MatrixUDG(String[] vexs, int[][] matrix) {

        // 初始化"顶点数"和"边数"
        int vlen = vexs.length;

        // 初始化"顶点"
        mVexs = new String[vlen];
        for (int i = 0; i < mVexs.length; i++)
            mVexs[i] = vexs[i];

        // 初始化"边"
        mMatrix = new int[vlen][vlen];
        for (int i = 0; i < vlen; i++)
            for (int j = 0; j < vlen; j++)
                mMatrix[i][j] = matrix[i][j];
    }

    /*
     * floyd最短路径。
     * 即，统计图中各个顶点间的最短路径。
     *
     * 参数说明：
     *     path -- 路径。path[i][j]=k表示，"顶点i"到"顶点j"的最短路径会经过顶点k。
     *     dist -- 长度数组。即，dist[i][j]=sum表示，"顶点i"到"顶点j"的最短路径的长度是sum。
     */
    public void floyd(int[][] path, int[][] dist) {

        // 初始化
        for (int i = 0; i < mVexs.length; i++) {
            for (int j = 0; j < mVexs.length; j++) {
                dist[i][j] = mMatrix[i][j];    // "顶点i"到"顶点j"的路径长度为"i到j的权值"。
                if (0 < dist[i][j] && dist[i][j] < INF) {
                    path[i][j] = i;
                } else {
                    path[i][j] = -1;
                }
            }
        }

        // 计算最短路径
        for (int k = 0; k < mVexs.length; k++) {
            for (int i = 0; i < mVexs.length; i++) {
                for (int j = 0; j < mVexs.length; j++) {

                    // 如果经过下标为k顶点路径比原两点间路径更短，则更新dist[i][j]和path[i][j]
                    int tmp = (dist[i][k]==INF || dist[k][j]==INF) ? INF : (dist[i][k] + dist[k][j]);
                    if (tmp < dist[i][j]) {
                        // "i到j最短路径"对应的值设，为更小的一个(即经过k)
                        dist[i][j] = tmp;
                        // "i到j最短路径"对应的路径，经过k
                        path[i][j] = path[k][j];
                    }
                }
            }
        }

        // 打印floyd最短路径的结果
        System.out.printf("floyd: \n");
        for (int i = 0; i < mVexs.length; i++) {
            for (int j = 0; j < mVexs.length; j++)
                System.out.printf("%2d  ", dist[i][j]);
            System.out.printf("\n");
        }

        // 打印floyd最短路径的结果
        System.out.printf("path: \n");
        for (int i = 0; i < mVexs.length; i++) {
            for (int j = 0; j < mVexs.length; j++)
                System.out.printf("%2d  ", path[i][j]);
            System.out.printf("\n");
        }

    }


    public static void main(String[] args) {
        String[] vexs = {"A", "B", "C", "D"};
        int matrix[][] = {
                 /*A*//*B*//*C*//*D*/
          /*A*/ {   0,   1, INF,   4},
          /*B*/ { INF,   0,   9,   2},
          /*C*/ {   3,   5,   0,   8},
          /*D*/ { INF, INF,   6,   0}};
        MatrixUDG pG;


        // 采用已有的"图"
        pG = new MatrixUDG(vexs, matrix);

        int[][] path = new int[pG.mVexs.length][pG.mVexs.length];
        int[][] floy = new int[pG.mVexs.length][pG.mVexs.length];
        // floyd算法获取各个顶点之间的最短距离
        pG.floyd(path, floy);


        int start = 1;
        int end = 2;
        //起点和终点在一起或者不可达时，返回
        if (path[start][end] == -1) {
            if (start == end) {
                System.out.println("起点和终点在一起");
            } else {
                System.out.println("两点不可达");
            }
            return;
        }

        List<String> list = new ArrayList<>();
        list.add(vexs[end]);
        while (path[start][end] != start) {
            end = path[start][end];
            list.add(vexs[end]);
        }
        list.add(vexs[start]);

        for (int i = list.size()-1; i>=0; i--) {
            System.out.println(list.get(i));
        }
    }

}