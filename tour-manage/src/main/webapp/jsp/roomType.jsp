<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

    <title>房间类型管理</title>

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

            initAllHotel();

            $("#searchbtn").click(function() {
                $("#t_roomType").datagrid('load', serializeForm($("#search")));
            });

            $("#clearbtn").click(function() {
                $("#search").form('clear');
                $("#t_roomType").datagrid('load', {});
            });

            saveBtnClick();

        });

        //初始化数据表格
        function initDataGrid() {
            $('#t_roomType').datagrid({

                //	title : '房间类型列表',
                url: '/manage/getRoomTypeList',
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
                        field: 'hotelId',
                        hidden: true
                    }, {
                        field: 'hotelName',
                        title: '酒店名称',
                        width: 150
                    }, {
                        field: 'typeName',
                        title: '房间类型名称',
                        width: 150
                    }, {
                        field: 'remark',
                        title: '类型介绍',
                        width: 200
                    }, {
                        field: 'price',
                        title: '价格',
                        width: 50,
                        sortable: true
                    }, {
                        field: 'indexImg',
                        title: '照片',
                        width: 150,
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
                        text: '新增房间类型',
                        iconCls: 'icon-add',
                        handler: add
                    }, {
                        text: '删除房间类型',
                        iconCls: 'icon-remove',
                        handler: del
                    }, {
                        text: '修改房间类型',
                        iconCls: 'icon-edit',
                        handler: edit
                    }
                ]
            });
        }

        //加载所有酒店
        function initAllHotel() {
            $('#spotId').empty();
            $.ajax({
                type: "POST",
                url: "/manage/getAllHotel",
                success: function(data) {
                    var inner = "";
                    for (var i = 0; i<data.length; i++) {
                        inner += " <option value='" + data[i].id + "'>" + data[i].hotelName + "</option>";
                    }
                    $('#hotelId').append(inner);
                }
            });
        }

        var flag;		//判断新增和修改

        function add() {
            flag = 'add';
            $("#mydialog").dialog({
                title: '新增房间类型',
                iconCls: 'icon-add'
            });
            $("#mydialog").dialog('open');
            $("#myform").get(0).reset();
            $("#id").val("");		//设id为空
            validate();
        }

        function edit() {
            flag = 'edit';
            var arr = $("#t_roomType").datagrid('getSelections');
            if (arr.length != 1) {
                $.messager.show({
                    title: '提示信息',
                    msg: '只能选择一行记录进行修改！'
                });
            } else {
                $("#mydialog").dialog({
                    title: '修改房间类型',
                    iconCls: 'icon-edit'
                });
                $('#mydialog').dialog('open'); //打开窗口
                $('#myform').get(0).reset();   //清空表单数据
                $('#myform').form('load', {	   //调用load方法把所选中的数据load到表单中
                    id: arr[0].id,
                    hotelId: arr[0].hotelId,
                    typeName: arr[0].typeName,
                    remark: arr[0].remark,
                    price: arr[0].price
                });
            }
            validate();
        }

        function del() {
            var arr = $("#t_roomType").datagrid('getSelections');
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
                            url: '/manage/delRoomType',
                            data: {'ids': ids},
                            success: function (data) {
                                //刷新数据表格
                                $("#t_roomType").datagrid('reload');
                                //清空idField
                                $("#t_roomType").datagrid('unselectAll');
                                $("#t_roomType").datagrid('clearSelections');
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

        //验证
        function validate() {
            $("#typeName").validatebox({
                required: true,
                missingMessage: '房间类型名称必填'
            });
            $("#remark").validatebox({
                required: true,
                missingMessage: '类型介绍必填'
            });
            $("#price").numberbox({
                required : true,
                missingMessage : '价格必填',
                precision : 0
            });
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
                url: flag == 'add' ? '/manage/addRoomType' : '/manage/editRoomType',
                type: 'POST',
                dataType: 'json',
                headers: {"ClientCallMode" : "ajax"}, //添加请求头部
                success: function(data) {
                    //关闭窗口
                    $("#mydialog").dialog('close');
                    //刷新datagrid
                    $("#t_roomType").datagrid('reload');
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
                <td align="right">房间类型:</td>
                <td><input type="text" name="typeName" value=""/></td>
                <td align="right">酒店名字:</td>
                <td><input type="text" name="hotelName" value=""/></td>
                <td align="right"><a id="searchbtn" class="easyui-linkbutton" iconCls="icon-search"></a></td>
                <td align="right"><a id="clearbtn" class="easyui-linkbutton">清空</a></td>
            </tr>
        </table>
    </form>

</div>

<table id="t_roomType"></table>

<div id="mydialog" class="easyui-dialog" closed="true" modal="true" draggable="true" style="width:450px; margin: 20px 40px">

    <form id="myform" method="post" enctype="multipart/form-data">
        <input id="id" type="hidden" name="id" value="" />
        <table>
            <tr>
                <td>酒店名称:</td>
                <td>
                    <select id="hotelId" name="hotelId" style="width:200px"></select>
                </td>
            </tr>

            <tr>
                <td>房间类型名称:</td>
                <td>
                    <input id="typeName" type="text" name="typeName" style="width:200px" />
                </td>
            </tr>

            <tr>
                <td>价格:</td>
                <td>
                    <input id="price" type="text" name="price" style="width:200px" />
                </td>
            </tr>

            <tr>
                <td>类型介绍:</td>
                <td>
                    <textarea id="remark" rows="4" cols="35" name="remark"></textarea>
                </td>
            </tr>

            <tr>
                <td>照片:</td>
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
