package cn.edu.hlju.tour.dao;

import cn.edu.hlju.tour.entity.Path;

import java.util.List;

public interface PathMapper {
    int deleteByPrimaryKey(Long id);

    int insert(Path record);

    int insertSelective(Path record);

    Path selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Path record);

    int updateByPrimaryKey(Path record);

    List<Path> selectAll();

    List<Path> selectByPath(Path path);

    void delBySpotId(Long[] ids);

    void insertBatch(List<Path> path);

}