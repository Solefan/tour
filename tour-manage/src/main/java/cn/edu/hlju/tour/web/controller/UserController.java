package cn.edu.hlju.tour.web.controller;

import cn.edu.hlju.tour.core.UserService;
import cn.edu.hlju.tour.entity.User;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Created by lft on 2017/3/2.
 */
@Controller
public class UserController {

    @Autowired
    private UserService userService;


    /**
     * 生成验证码
     * @param request
     * @param response
     */
    @RequestMapping(value = "verifyCode")
    @ResponseBody
    public void verifyCode(HttpServletRequest request, HttpServletResponse response) {
        try {
            userService.verifyCode(request, response);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 登录
     * @param request
     * @return
     */
    @RequestMapping(value = "login")
    @ResponseBody
    public String login(HttpServletRequest request) {
        String serverVerifyCode = (String)request.getSession().getAttribute("verifyCode");
        String verifyCode = request.getParameter("verifyCode");
        if (!userService.isVerifyCode(verifyCode, serverVerifyCode)) {
            return "verifyCodeError";
        }
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        User user = userService.login(email, password, 1L);
        if (user == null) {
            return "userNotExist";
        }
        request.getSession().setAttribute("user", user);
        return "success";
    }

    /**
     * 退出
     * @param request
     */
    @RequestMapping(value = "logout")
    @ResponseBody
    public void logout(HttpServletRequest request) {
        request.getSession().invalidate();
    }

    /**
     * 查询用户列表
     * @param page 当前页
     * @param rows 一页有多少
     * @param user 查询的字段的封装
     * @return
     */
    @RequestMapping(value= "getUserList")
    @ResponseBody
    public String getUserList(int page, int rows, User user) {

        //{"total":10, "row":[{},{}]}
        user.setPermission(0L);

        JSONObject json = userService.selectUserByPage(page, rows, user);

        PageInfo pageInfo = (PageInfo)json.get("pageinfo");//获取分页信息
        List<User> list = (List)json.get("list");
        long total = pageInfo.getTotal();
        String str = JSON.toJSONString(list);
        String jsonStr = "{\"total\":" + total + ", \"rows\":" + str + "}";
        return jsonStr;

    }

    @RequestMapping(value= "delUser")
    @ResponseBody
    public void delUser(@RequestParam("ids") String idsTemp) {
        String[] tempArray = idsTemp.split(",");
        Long[] ids = new Long[tempArray.length];
        for (int i = 0; i<tempArray.length; i++) {
            ids[i] = Long.parseLong(tempArray[i]);
        }
        userService.delUser(ids);
    }

    @RequestMapping(value= "editUser")
    @ResponseBody
    public void editUser(User user) {
        userService.update(user);
    }

}
