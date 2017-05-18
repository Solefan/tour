<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

    <title>景点图片管理</title>

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

            initAllSpot();

            $("#searchbtn").click(function() {
                $("#t_spotImg").datagrid('load', serializeForm($("#search")));
            });

            $("#clearbtn").click(function() {
                $("#search").form('clear');
                $("#t_spotImg").datagrid('load', {});
            });

            saveBtnClick();

        });

        //初始化数据表格
        function initDataGrid() {
            $('#t_spotImg').datagrid({

                //	title : '景点图片列表',
                url: '/manage/getSpotImgList',
                idField: 'id',

                height: 500,
                striped: true,
                rownumbers: true,
                fitColumns: true,
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
                        width: 50,
                        sortable: true
                    }, {
                        field: 'spotId',
                        hidden: true
                    }, {
                        field: 'img',
                        title: '图片',
                        width: 50,
                        align: 'center',
                        formatter : function(value, record, index) {
                            var str = '';
                            str = "<img style='width:30%; height:20%; border-radius: 5%;' src='" + value + "'>";
                            return str;
                        }
                    }
                ]],
                toolbar: [
                    {
                        text: '新增景点图片',
                        iconCls: 'icon-add',
                        handler: add
                    }, {
                        text: '删除景点图片',
                        iconCls: 'icon-remove',
                        handler: del
                    }, {
                        text: '更换景点图片',
                        iconCls: 'icon-edit',
                        handler: edit
                    }
                ]
            });
        }

        // 加载所有景点    模态窗口
        function initAllSpot() {
            $('#spotId').empty();
            $.ajax({
                type: "POST",
                url: "/manage/getAllSpot",
                success: function(data) {
                    var inner = "";
                    for (var i = 0; i<data.length; i++) {
                        inner += " <option value='" + data[i].id + "'>" + data[i].spotName + "</option>";
                    }
                    $('#spotId').append(inner);
                }
            });
        }

        var flag;		//判断新增和修改

        function add() {
            flag = 'add';
            $("#mydialog").dialog({
                title: '新增景点图片',
                iconCls: 'icon-add'
            });
            $("#mydialog").dialog('open');
            $("#myform").get(0).reset();
            $("#id").val("");		//设id为空
        }

        function edit() {
            flag = 'edit';
            var arr = $("#t_spotImg").datagrid('getSelections');
            if (arr.length != 1) {
                $.messager.show({
                    title: '提示信息',
                    msg: '只能选择一行记录进行修改！'
                });
            } else {
                $("#mydialog").dialog({
                    title: '修改景点图片',
                    iconCls: 'icon-edit'
                });
                $('#mydialog').dialog('open'); //打开窗口
                $('#myform').get(0).reset();   //清空表单数据
                $('#myform').form('load', {	   //调用load方法把所选中的数据load到表单中
                    id: arr[0].id,
                    spotId: arr[0].spotId
                });
            }
        }

        function del() {
            var arr = $("#t_spotImg").datagrid('getSelections');
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
                            url: '/manage/delSpotImg',
                            data: {'ids': ids},
                            success: function (data) {
                                //刷新数据表格
                                $("#t_spotImg").datagrid('reload');
                                //清空idField
                                $("#t_spotImg").datagrid('unselectAll');
                                $("#t_spotImg").datagrid('clearSelections');
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
                url: flag == 'add' ? '/manage/addSpotImg' : '/manage/editSpotImg',
                type: 'POST',
                dataType: 'json',
                headers: {"ClientCallMode" : "ajax"}, //添加请求头部
                success : function(data) {
                    //关闭窗口
                    $("#mydialog").dialog('close');
                    //刷新datagrid
                    $("#t_spotImg").datagrid('reload');
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

<table id="t_spotImg"></table>

<div id="mydialog" class="easyui-dialog" closed="true" modal="true" draggable="true" style="width:370px; margin: 20px 40px">

    <form id="myform" method="post" enctype="multipart/form-data">
        <input id="id" type="hidden" name="id" value="" />
        <table>
            <tr>
                <td>景点名称:</td>
                <td>
                    <select id="spotId" name="spotId" style="width:200px"></select>
                </td>
            </tr>

            <tr>
                <td>图片:</td>
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
