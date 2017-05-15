<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

    <title>景点管理</title>

    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">

    <link rel="stylesheet" type="text/css" href="../resources/css/common.css">
    <link rel="stylesheet" type="text/css" href="../resources/js/jquery-easyui-1.2.6/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="../resources/js/jquery-easyui-1.2.6/themes/icon.css">

    <script type="text/javascript" src="../resources/js/jquery-easyui-1.2.6/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="../resources/js/jquery-easyui-1.2.6/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../resources/js/jquery-easyui-1.2.6/jquery.form.min.js"></script>
    <script type="text/javascript" src="../resources/js/jquery-easyui-1.2.6/locale/easyui-lang-zh_CN.js"></script>

    <script type="text/javascript">
        $(function () {

            initDataGrid();

            $("#searchbtn").click(function() {
                $("#t_spot").datagrid('load', serializeForm($("#search")));
            });

            $("#clearbtn").click(function() {
                $("#search").form('clear');
                $("#t_spot").datagrid('load', {});
            });

            saveBtnClick();

        });

        //初始化数据表格
        function initDataGrid() {
            $('#t_spot').datagrid({

                //	title : '景点列表',
                url: '/manage/getSpotList',
                idField: 'id',

                height: 500,
                striped: true,
                rownumbers: true,
                fitColumns: false,
                pagination: true,
                pageSize: 10,
                pageList: [5, 10, 15, 20],
                remoteSort: false,
                columns: [[
                    {
                        checkbox: true,
                        width: 10
                    }, {
                        field: 'spotName',
                        title: '景点名称',
                        width: 150,
                    }, {
                        field: 'spotIntroduce',
                        title: '景点介绍',
                        width: 200,
                    }, {
                        field: 'spendTime',
                        title: '花费时间',
                        width: 100
                    }, {
                        field: 'traffic',
                        title: '交通状况',
                        width: 200,
                    }, {
                        field: 'ticket',
                        title: '票价',
                        width: 150
                    }, {
                        field: 'openTime',
                        title: '开放时间',
                        width: 100,
                    }, {
                        field: 'location',
                        title: '地址',
                        width: 250
                    }, {
                        field: 'coordinate',
                        title: '坐标',
                        width: 200,
                    }, {
                        field: 'indexImg',
                        title: '图片',
                        width: 200,
                        align: 'center',
                        formatter : function(value, record, index) {
                            var str = '';
                            str = "<img style='width:50%; height:60px; border-radius: 5%;' src='" + value + "'>";
                            return str;
                        }
                    }
                ]],
                toolbar: [
                    {
                        text: '新增景点',
                        iconCls: 'icon-add',
                        handler: add
                    }, {
                        text: '删除景点',
                        iconCls: 'icon-remove',
                        handler: del
                    }, {
                        text: '修改景点',
                        iconCls: 'icon-edit',
                        handler: edit
                    }
                ]
            });
        }

        var flag;		//判断新增和修改

        function add() {
            flag = 'add';
            $("#mydialog").dialog({
                title: '新增景点',
                iconCls: 'icon-add'
            });
            $("#mydialog").dialog('open');
            $("#myform").get(0).reset();
            $("#id").val("");		//设id为空
            validate();
        }

        function edit() {
            flag = 'edit';
            var arr = $("#t_spot").datagrid('getSelections');
            if (arr.length != 1) {
                $.messager.show({
                    title: '提示信息',
                    msg: '只能选择一行记录进行修改！'
                });
            } else {
                $("#mydialog").dialog({
                    title: '修改景点',
                    iconCls: 'icon-edit'
                });
                $('#mydialog').dialog('open'); //打开窗口
                $('#myform').get(0).reset();   //清空表单数据
                $('#myform').form('load', {	   //调用load方法把所选中的数据load到表单中
                    id: arr[0].id,
                    spotName: arr[0].spotName,
                    spotIntroduce: arr[0].spotIntroduce,
                    spendTime: arr[0].spendTime,
                    traffic: arr[0].traffic,
                    ticket: arr[0].ticket,
                    openTime: arr[0].openTime,
                    location: arr[0].location,
                    coordinate: arr[0].coordinate,
                });
            }
            validate();
        }

        //验证
        function validate() {
            $("#spotName").validatebox({
                required: true,
                missingMessage: '景点名称必填'
            });
            $("#spotIntroduce").validatebox({
                required: true,
                missingMessage: '景点介绍必填'
            });
            $("#spendTime").validatebox({
                required: true,
                missingMessage: '花费时间必填'
            });
            $("#traffic").validatebox({
                required: true,
                missingMessage: '交通状况必填'
            });
            $("#ticket").validatebox({
                required: true,
                missingMessage: '门票必填'
            });
            $("#openTime").validatebox({
                required: true,
                missingMessage: '开放时间必填'
            });
            $("#location").validatebox({
                required: true,
                missingMessage: '位置必填'
            });
            $("#coordinate").validatebox({
                required: true,
                missingMessage: '坐标必填'
            });
        }

        function del() {
            var arr = $("#t_spot").datagrid('getSelections');
            if (arr.length <= 0) {
                $.messager.show({
                    title: '提示信息',
                    msg: '至少选择一条记录进行删除操作！'
                });
            } else {
                var ids = '';
                for (var i = 0; i < arr.length; i++) {
                    ids += arr[i].id + ',';
                }
                ids = ids.substring(0, ids.length - 1);
                $.messager.confirm('提示信息', '确认删除？', function (r) {
                    if (r) {
                        $.ajax({
                            type: 'post',
                            cache: false,
                            url: '/manage/delSpot',
                            data: {'ids': ids},
                            success: function (data) {
                                //刷新数据表格
                                $("#t_spot").datagrid('reload');
                                //清空idField
                                $("#t_spot").datagrid('unselectAll');
                                $("#t_spot").datagrid('clearSelections');
                                $.messager.show({
                                    title: '提示信息',
                                    msg: '删除成功！'
                                });
                            },
                            error: function (data) {
                                $.messager.show({
                                    title: '提示信息',
                                    msg: '删除失败！'
                                });
                            }
                        });
                    } else {
                        return;
                    }
                });
            }
        }

        //表单的序列化
        function serializeForm(form){
            var obj = {};
            $.each(form.serializeArray(), function(index){
                if (obj[this['name']]) {
                    obj[this['name']] = obj[this['name']] + ',' + this['value'];
                } else {
                    obj[this['name']] = this['value'];
                }
            });
            return obj;
        }

        function saveBtnClick() {
            $("#saveBtn").click(function() {
                if (!$("#myform").form('validate')) {
                    $.messager.show({
                        title: '提示信息',
                        msg: '验证没有通过, 不能提交表单',
                    });
                } else {
                    if (flag == 'add' && $('#file').val() == "") {
                        $.messager.show({
                            title: '提示信息',
                            msg: '请上传图片',
                        });
                        return;
                    }
                    ajaxSubmitForm();
                }
            });
        }

        function ajaxSubmitForm() {
            var option = {
                url: flag == 'add' ? '/manage/addSpot' : '/manage/editSpot',
                type: 'POST',
                dataType: 'json',
                headers: {"ClientCallMode" : "ajax"}, //添加请求头部
                success : function(data) {
                    //关闭窗口
                    $("#mydialog").dialog('close');
                    //刷新datagrid
                    $("#t_spot").datagrid('reload');
                    $.messager.show({
                        title: '提示信息',
                        msg: '操作成功！'
                    });
                },
                error: function(data) {
                    $.messager.show({
                        title: '提示信息',
                        msg: '操作失败！'
                    });
                }
            };
            $("#myform").ajaxSubmit(option);
        }

    </script>

</head>

<body>
<div id="panel" class="easyui-panel" title="查询入口" style="height:70; padding:6; overflow:hidden">

    <form id="search">
        <table style="width:70%">
            <tr>
                <td align="right">景点:</td>
                <td><input type="text" name="spotName" value=""/></td>
                <td align="right"><a id="searchbtn" class="easyui-linkbutton" iconCls="icon-search"></a></td>
                <td align="right"><a id="clearbtn" class="easyui-linkbutton">清空</a></td>
            </tr>
        </table>
    </form>

</div>

<table id="t_spot"></table>

<div id="mydialog" class="easyui-dialog" closed="true" modal="true" draggable="true" style="width:530px; margin: 20px 40px">

    <form id="myform" method="post" enctype="multipart/form-data">
        <input id="id" type="hidden" name="id" value="" />
        <table>
            <tr>
                <td>景点名称:</td>
                <td><input id="spotName" type="text" name="spotName" value="" style="width:200px" /></td>
            </tr>

            <tr>
                <td>用时参考:</td>
                <td><input id="spendTime" type="text" name="spendTime" value="" style="width:200px" /></td>
            </tr>

            <tr>
                <td>开放时间:</td>
                <td><input id="openTime" type="text" name="openTime" value="" style="width:200px" /></td>
            </tr>

            <tr>
                <td>票价:</td>
                <td><input id="ticket" type="text" name="ticket" value="" style="width:200px" /></td>
            </tr>

            <tr>
                <td>坐标:</td>
                <td>
                    <input id="coordinate" type="text" name="coordinate" value="" style="width:200px" />
                    <a href="http://lbs.amap.com/console/show/picker" target="_blank">坐标拾取器</a>
                </td>
            </tr>

            <tr>
                <td>地址:</td>
                <td><input id="location" type="text" name="location" value="" style="width:370px" /></td>
            </tr>

            <tr>
                <td>交通状况:</td>
                <td>
                    <textarea id="traffic" rows="3" cols="50" name="traffic"></textarea>
                </td>
            </tr>

            <tr>
                <td>景点介绍:</td>
                <td>
                    <textarea id="spotIntroduce" rows="8" cols="50" name="spotIntroduce"></textarea>
                </td>
            </tr>

            <tr>
                <td>主页照片:</td>
                <td>
                    <input id="file" type="file" name="file" accept="image/*" />
                </td>
            </tr>

            <tr align="center">
                <td colspan="2"><a id="saveBtn" class="easyui-linkbutton" iconCls="icon-save">保存</a></td>
            </tr>

        </table>
    </form>
</div>

</body>

</html>
