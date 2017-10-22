<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<jsp:include page="/WEB-INF/jsp/common/base.jsp"></jsp:include>
	<link rel="stylesheet" href="${appPath }/css/main.css">
    <link rel="stylesheet" href="${appPath }/css/doc.min.css">
	<style>
	.tree li {
		list-style-type: none;
		cursor:pointer;
	}
	</style>
 </head>

  <body>
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
      <div class="container-fluid">
        <div class="navbar-header">
            <div><a class="navbar-brand" style="font-size:32px;" href="user.html">众筹平台 - 用户维护</a></div>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav navbar-right">
            <li style="padding-top:8px;">
				<%@ include file="/WEB-INF/jsp/common/userinfo.jsp" %>
			</li>
            <li style="margin-left:10px;padding-top:8px;">
				<button type="button" class="btn btn-default btn-danger">
				  <span class="glyphicon glyphicon-question-sign"></span> 帮助
				</button>
			</li>
          </ul>
          <form class="navbar-form navbar-right">
            <input type="text" class="form-control" placeholder="Search...">
          </form>
        </div>
      </div>
    </nav>

    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
			<jsp:include page="/WEB-INF/jsp/common/menu.jsp"></jsp:include>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
				<ol class="breadcrumb">
				  <li><a href="#">首页</a></li>
				  <li><a href="#">数据列表</a></li>
				  <li class="active">批量新增</li>
				</ol>
			<div class="panel panel-default">
              <div class="panel-heading">表单数据<div style="float:right;cursor:pointer;" data-toggle="modal" data-target="#myModal"><i class="glyphicon glyphicon-question-sign"></i></div></div>
			  <div class="panel-body">
				<form role="form" id="batchAddForm" action="${appPath }/manager/user/batchInsert.htm" method="post">
				  <table class="table table-striped table-bordered" style="align:center">
				  	<thead>
				  		<tr>
				  			<td>登陆账号</td>
				  			<td>用户名称</td>
				  			<td>邮箱地址</td>
				  			<td>操作</td>
				  		</tr>
				  	</thead>
				  	<tbody id="tBody">
				  		<!-- <tr>
				  			<td><input class="form-control" type="text" name="account"></td>
				  			<td><input class="form-control" type="text" name="username"></td>
				  			<td><input class="form-control" type="text" name="email"></td>
				  			<td><a type="button" class="btn btn-danger" href="#">删除</a></td>
				  		</tr> -->
				  	</tbody>
				  	<tfoot>
				  		<button id="insertRowBtn" type="button" style="margin-bottom:10px" class="btn btn-success"><i class="glyphicon glyphicon-plus"></i> 添加数据</button>
				  		<button id="batchAdd" type="button" style="margin-left:10px;margin-bottom:10px" class="btn btn-danger"><i class="glyphicon glyphicon-save"></i> 保存数据</button>
				  	</tfoot>
				  </table>
				</form>
			  </div>
			</div>
        </div>
      </div>
    </div>
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	  <div class="modal-dialog">
		<div class="modal-content">
		  <div class="modal-header">
			<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
			<h4 class="modal-title" id="myModalLabel">帮助</h4>
		  </div>
		  <div class="modal-body">
			<div class="bs-callout bs-callout-info">
				<h4>测试标题1</h4>
				<p>测试内容1，测试内容1，测试内容1，测试内容1，测试内容1，测试内容1</p>
			  </div>
			<div class="bs-callout bs-callout-info">
				<h4>测试标题2</h4>
				<p>测试内容2，测试内容2，测试内容2，测试内容2，测试内容2，测试内容2</p>
			  </div>
		  </div>
		  <!--
		  <div class="modal-footer">
			<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
			<button type="button" class="btn btn-primary">Save changes</button>
		  </div>
		  -->
		</div>
	  </div>
	</div>
	<script src="${appPath }/jquery/jquery-2.1.1.min.js"></script>
    <script src="${appPath }/bootstrap/js/bootstrap.min.js"></script>
    <script src="${appPath }/script/docs.min.js"></script>
	<script src="${appPath }/script/layer/layer.js"></script>
    <script type="text/javascript">
        $(function () {
		   $(".list-group-item").click(function(){
			    if ( $(this).find("ul") ) {
					$(this).toggleClass("tree-closed");
					if ( $(this).hasClass("tree-closed") ) {
						$("ul", this).hide("fast");
					} else {
						$("ul", this).show("fast");
					}
				}
			});
		   var rowIndex = 0;
			$("#insertRowBtn").click(function(){
				var tableContent = "";
				tableContent = tableContent + '<tr>';
		  		tableContent = tableContent + '	<td><input class="form-control" type="text" name="users['+ rowIndex +'].account" placeholder="请输入登陆账号"></td>';
		  		tableContent = tableContent + '	<td><input class="form-control" type="text" name="users['+ rowIndex +'].username" placeholder="请输入用户名称"></td>';
		  		tableContent = tableContent + '	<td><input class="form-control" type="text" name="users['+ rowIndex +'].email" placeholder="请输入邮箱地址"></td>';
		  		tableContent = tableContent + '	<td><a onclick="deleteRow(this)" class="btn btn-danger" role="button"><i class="glyphicon glyphicon-remove"></i></a></td>';
	  			tableContent = tableContent + '</tr>';
	  			$("#tBody").append(tableContent);
	  			rowIndex++;
			});
			$("#batchAdd").click(function(){
				$("#batchAddForm").submit();
			});
		});
        function deleteRow(obj) {
			var trObj = $(obj).parent().parent();
			trObj.remove();
		}
	</script>
	</body>
</html>
