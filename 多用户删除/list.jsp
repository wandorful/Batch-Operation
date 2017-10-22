<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <jsp:include page="/WEB-INF/jsp/common/base.jsp"></jsp:include>
    <link rel="stylesheet" href="${appPath }/css/main.css">
	<style>
		.tree li {
	        list-style-type: none;
			cursor:pointer;
		}
		table tbody tr:nth-child(odd){background:#F4F4F4;}
		table tbody td:nth-child(even){color:#C00;}
	</style>
  </head>
  <body>
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
      <div class="container-fluid">
        <div class="navbar-header">
          <div><a class="navbar-brand" style="font-size:32px;" href="#">众筹平台 - 用户维护</a></div>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav navbar-right">
            <li style="padding-top:8px;">
				<%@include file="/WEB-INF/jsp/common/userinfo.jsp" %>
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
			<div class="panel panel-default">
			  <div class="panel-heading">
				<h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
			  </div>
			  <div class="panel-body">
				<form class="form-inline" role="form" style="float:left;">
				  <div class="form-group has-feedback">
				    <div class="input-group">
				      <div class="input-group-addon">查询条件</div>
				      <input id="queryCondition" class="form-control has-success" type="text" placeholder="请输入查询条件">
				    </div>
				  </div>
				  <button type="button" id="queryBtn" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
				</form>
				<button type="button" class="btn btn-danger" style="float:right;margin-left:10px;" onclick="deleteUsers()"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
				<button type="button" class="btn btn-primary" style="float:right;margin-left:10px;" onclick="window.location.href='${appPath }/manager/user/add.htm'"><i class="glyphicon glyphicon-plus"></i> 新增</button>
				<button type="button" class="btn btn-primary" style="float:right;" onclick="window.location.href='${appPath }/manager/user/multiadd.htm'"><i class="glyphicon glyphicon-plus"></i> 批量新增</button>
				<br>
				<hr style="clear:both;">
		        <div class="table-responsive">
		          <table class="table  table-bordered">
		            <thead>
		              <tr >
		                <th width="30">#</th>
				  <th width="30"><input type="checkbox" id="selectAllCheckBox"></th>
		                <th>账号</th>
		                <th>名称</th>
		                <th>邮箱地址</th>
		                <th width="100">操作</th>
		              </tr>
		            </thead>
		            <tbody id="contentBody">
			<%--
		            <c:forEach items="${requestScope.users }" var="user">
		              <tr>
					<td>${user.id }</td>
					<td><input type="checkbox"></td>
					<td>${user.account }</td>
					<td>${user.username }</td>
					<td>${user.email }</td>
					<td>
						<button type="button" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>
						<button type="button" class="btn btn-primary btn-xs"><i class=" glyphicon glyphicon-pencil"></i></button>
						<button type="button" class="btn btn-danger btn-xs"><i class=" glyphicon glyphicon-remove"></i></button>
				  </td>
		              </tr>
			  </c:forEach>
			   --%>
		            </tbody>
					<tfoot>
					   <tr >
					    <td colspan="6" align="center">
						<ul class="pagination">
					<%--
						<c:if test="${requestScope.pageNo != 1 }">
							<li style="cursor: pointer"><a href="${appPath }/manager/user/list.htm?pageNo=${requestScope.pageNo - 1 }">上一页</a></li>
						</c:if>
						<c:forEach begin="1" end="${requestScope.totalPage }" var="index">
							<c:if test="${requestScope.pageNo == index }">
								<li class="active"><a href="#">${index }<span class="sr-only">(current)</span></a></li>
							</c:if>
							<c:if test="${requestScope.pageNo != index }">
								<li><a href="${appPath }/manager/user/list.htm?pageNo=${index }">${index }</a></li>
							</c:if>
						</c:forEach>
						<c:if test="${requestScope.pageNo != totalPage }">
							<li style="cursor: pointer"><a href="${appPath }/manager/user/list.htm?pageNo=${requestScope.pageNo + 1 }">下一页</a></li>
						</c:if>
						--%>
						 </ul>
					 </td>
					
					</tr>
					</tfoot>
		          </table>
		        </div>
			  </div>
			</div>
        </div>
      </div>
    </div>
    <script src="${appPath }/jquery/jquery-2.1.1.min.js"></script>
    <script src="${appPath }/bootstrap/js/bootstrap.min.js"></script>
    <script src="${appPath }/script/docs.min.js"></script>
    <script src="${appPath }/script/layer/layer.js"></script>
    <script type="text/javascript">
     $(function () {
         $("#userManage").attr("style", "color:red;");
         $("#userManage").parents("ul").show();
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
    <c:if test="${empty param.pageNo}">
	    pageQuery(1);
    </c:if>
    <%-- 进行更新的时候 --%>
    <c:if test="${not empty param.pageNo}">
    	pageQuery(${param.pageNo});
   	</c:if>
          <%-- 条件查询 --%>
          $("#queryBtn").click(function(){
          	var queryInput = $("#queryCondition");
          	if(queryInput.val() == "") {
          		layer.msg("查询条件不能为空！", {time:1000, icon:5, shift:6}, function(){
          			queryInput.focus();
          		});
          		return false;
          	}
          	condQuery = true;
          	pageQuery(1);
          });
          $("#selectAllCheckBox").click(function() {
        	  var status = this.checked;
        	  var checkboxes = $("tbody :checkbox");
        	  $.each(checkboxes, function(i, n) {
        		  n.checked = status;
        	  });
          });

          $("tbody").delegate("input[type='checkbox']", "click", function() {
        	  if ($("tbody :checked") == 0) {
        		  $("#selectAllCheckBox")[0].checked = false;
        	  } else {
        		  $("#selectAllCheckBox")[0].checked = true;
        	  }
        	  $("tbody :checbox").change(function() {
        		  alert("llll");
        	  });
          });
         });

         function deleteUsers() {
         	var chUsers = $("tbody :checked");
         	if(chUsers.length == 0) {
         		layer.msg("请选择要删除的用户信息", {time:1000, icon:5, shift:6});
         	} else {
         		if(chUsers.length == pageSize) {
         			$("#selectAllCheckBox").checked;
         		}
         		var jsonData = {};
             	$.each(chUsers, function(i, chU) {
             		jsonData["ids["+i+"]"] = chU.value;
             	});
             	var loadingIndex = -1;
             	$.ajax({
             		url:"${appPath}/manager/user/deleteUsers.do",
             		data:jsonData,
             		type:"POST",
             		dataType:"JSON",
             		beforeSend:function() {
             			loadingIndex = layer.load(2, {time:3*1000});
             		},
             		success:function(result) {
             			layer.close(loadingIndex);
             			if(result.success) {
             				layer.msg("删除成功！", {time:1000, icon:6, shift:6}, function() {
             					//pageQuery(1);
             					window.location.href="${appPath}/manager/user/list.htm";
             				});
             			} else {
             				layer.msg("删除失败！", {time:1000, icon:5, shift:6});
             			}
             		}
             	});
         	}
         }
         function deleteUser(id, account) {
        	 layer.confirm("确定要删除 " + account + " 的用户信息吗？", {icon: 3, title:'提示'}, function(cindex){
        		 window.location.href="${appPath}/manager/user/delUser.do?id=" + id;
                 layer.close(cindex);
             }, function(cindex){
                 layer.close(cindex);
             });
         }
         function changePageNo(pageNo) {
         	pageQuery(pageNo);
         }
         var pageSize = 3;
         var condQuery = false;
         function pageQuery(pageNo) {
         	var loadingIndex = -1;
         	var jsonData = {'pageNo':pageNo,'pageSize':pageSize};
         	if(condQuery) {
         		jsonData["condLine"] = $("#queryCondition").val();
         	}
         	$.ajax({
         		url:"${appPath}/manager/user/pageQuery.do",
         		data:jsonData,
         		type:"POST",
         		beforeSend:function(){
         			loadingIndex = layer.load(2, {time:3*1000})
         		},
         		success:function(result){
         			layer.close(loadingIndex);
         			if(result.success) {
         				var pageObj = result.page;
         				var users = pageObj.list;
         				var pageNum = pageObj.pageNo;
         				var userContent = "";
         				$.each(users, function(i, usr){
         					userContent = userContent + '<tr>';
         	                userContent = userContent + '  <td>' + (i+1) +'</td>';
         					userContent = userContent + '  <td><input type="checkbox" onclick="selectUser(this)" value="'+usr.id+'"></td>';
         	                userContent = userContent + '  <td>' + usr.account + '</td>';
         	                userContent = userContent + '  <td>' + usr.username + '</td>';
         	                userContent = userContent + '  <td>' + usr.email + '</td>';
         	                userContent = userContent + '  <td>';
         					userContent = userContent + '      <button onclick="window.location.href=\'${appPath}/manager/user/toAssignRole.htm?id='+usr.id+'\'" type="button" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>';
         					userContent = userContent + '      <button onclick="window.location.href=\'${appPath}/manager/user/edit.do?pageNo='+pageNum+'&id='+usr.id+'\'" type="button" class="btn btn-primary btn-xs"><i class=" glyphicon glyphicon-pencil"></i></button>';
         					userContent = userContent + '	  <button onclick="deleteUser('+usr.id+',\''+usr.account+'\')" type="button" class="btn btn-danger btn-xs"><i class=" glyphicon glyphicon-remove"></i></button>';
         					userContent = userContent + '  </td>';
         	                userContent = userContent + '</tr>';
         				});
         				$("#contentBody").empty();
         				$("#contentBody").append(userContent);
         				var pageNoContent = "";
         				var totalPageNo = pageObj.totalPageNo;
         				var pageNo = pageObj.pageNo;
         				if(pageNo != 1) {
         					pageNoContent = pageNoContent + '<li style="cursor: pointer"><a onclick="changePageNo('+ (pageNo - 1) +')">上一页</a></li>';
         				}
						for(var i = 1; i<= totalPageNo; i++){
							if(i == pageNo) {
								pageNoContent = pageNoContent + '<li class="active"><a onclick="changePageNo('+ i +')">' + i + '<span class="sr-only">(current)</span></a></li>';
							} else {
								pageNoContent = pageNoContent + '<li><a style="cursor: pointer;" onclick="changePageNo('+ i +')">' + i + '</a></li>';
							}
						}
						if(pageNo != totalPageNo) {
							pageNoContent = pageNoContent + '<li style="cursor: pointer"><a onclick="changePageNo('+ (pageNo + 1) +')">下一页</a></li>';
						}
						$(".pagination").empty();
						$(".pagination").append(pageNoContent);
         			} else {
         				layer.msg("分页查询失败！", {time:1000, icon:5, shift:6});
         			}
         		}
       	   });
         }
    </script>
  </body>
</html>
