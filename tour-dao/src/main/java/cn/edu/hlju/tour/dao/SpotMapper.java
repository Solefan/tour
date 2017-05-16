package cn.edu.hlju.tour.dao;

import cn.edu.hlju.tour.entity.Spot;

import java.util.List;

public interface SpotMapper {
    int deleteByPrimaryKey(Long id);

    int insert(Spot record);

    int insertSelective(Spot record);

    Spot selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Spot record);

    int updateByPrimaryKey(Spot record);

    Spot selectBySpotName(String spotname);

    List<Spot> selectAll();

    List<Spot> selectBySpot(Spot spot);

    void delBySpotId(Long[] ids);
}