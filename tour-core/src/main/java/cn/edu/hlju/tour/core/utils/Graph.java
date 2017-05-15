package cn.edu.hlju.tour.core.utils;

/**
 * Created by lft on 2017/5/14.
 */
public class Graph {

    private Long[] vexs;                                // 顶点集合
    private int[][] matrix;                             // 邻接矩阵
    public static final int INF = Integer.MAX_VALUE;    // 最大值

    public Graph() {
    }

    /**
     * 创建图(用已提供的矩阵)
     *
     * 参数说明：
     *     vexs  -- 顶点数组
     *     matrix-- 矩阵(数据)
     */
    public Graph(Long[] vexs, int[][] matrix) {

        // 初始化"顶点数"和"边数"
        int vlen = vexs.length;

        // 初始化"顶点"
        vexs = new Long[vlen];
        for (int i = 0; i < vexs.length; i++) {
            vexs[i] = vexs[i];
        }

        // 初始化"边"
        matrix = new int[vlen][vlen];
        for (int i = 0; i < vlen; i++) {
            for (int j = 0; j < vlen; j++) {
                matrix[i][j] = matrix[i][j];
            }
        }
    }

    public Long[] getVexs() {
        return vexs;
    }

    public void setVexs(Long[] vexs) {
        this.vexs = vexs;
    }

    public int[][] getMatrix() {
        return matrix;
    }

    public void setMatrix(int[][] matrix) {
        this.matrix = matrix;
    }
}
