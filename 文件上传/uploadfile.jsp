<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <jsp:include page="/WEB-INF/jsp/common/base.jsp"></jsp:include>
    <link rel="stylesheet" href="${appPath }/css/theme.css">
    <style>
		#footer {
		    padding: 15px 0;
		    background: #fff;
		    border-top: 1px solid #ddd;
		    text-align: center;
		}
    </style>
  </head>
  <body>
    <div class="navbar-wrapper">
      <div class="container">
        <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
          <div class="container">
            <div class="navbar-header">
              <a class="navbar-brand" href="index.html" style="font-size:32px;">尚筹网-创意产品众筹平台</a>
            </div>
	        <div id="navbar" class="navbar-collapse collapse" style="float:right;">
	          <ul class="nav navbar-nav">
	            <li class="dropdown">
	              <a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="glyphicon glyphicon-user"></i> 张三<span class="caret"></span></a>
	              <ul class="dropdown-menu" role="menu">
	                <li><a href="member.html"><i class="glyphicon glyphicon-scale"></i> 会员中心</a></li>
	                <li><a href="#"><i class="glyphicon glyphicon-comment"></i> 消息</a></li>
	                <li class="divider"></li>
	                <li><a href="index.html"><i class="glyphicon glyphicon-off"></i> 退出系统</a></li>
	              </ul>
	            </li>
	          </ul>
	        </div>
          </div>
        </nav>
      </div>
    </div>

    <div class="container theme-showcase" role="main">
      <div class="page-header">
        <h1>实名认证 - 申请</h1>
      </div>

      <ul class="nav nav-tabs" role="tablist">
        <li role="presentation" ><a href="#"><span class="badge">1</span> 基本信息</a></li>
        <li role="presentation" class="active"><a href="#"><span class="badge">2</span> 资质文件上传</a></li>
        <li role="presentation"><a href="#"><span class="badge">3</span> 邮箱确认</a></li>
        <li role="presentation"><a href="#"><span class="badge">4</span> 申请确认</a></li>
      </ul>

      <form id="uploadCertForm" role="form" style="margin-top:20px;" method="post" enctype="multipart/form-data">
      <c:forEach items="${requestScope.requiredCerts }" var="cert" varStatus="status">
        <div class="form-group">
          <label for="IDCardImg">${cert.name }</label>
          <input type="hidden" name="certImgs[${status.index }].certid" value="${cert.id }">
          <input type="file" class="form-control" name="certImgs[${status.index }].certImgFile" placeholder="请选择要上传的资质文件">
          <img src="${appPath }/img/pic.jpg" style="display:none">
        </div>
      </c:forEach>
        <button type="button" id="prevBtn" class="btn btn-default">上一步</button>
        <button type="button" id="nextBtn" class="btn btn-success">下一步</button>
      </form>
      <hr>
    </div> <!-- /container -->
    <div class="container" style="margin-top:20px;">
        <div class="row clearfix">
            <div class="col-md-12 column">
                <div id="footer">
                    <div class="footerNav">
                         <a rel="nofollow" href="http://www.atguigu.com">关于我们</a> | <a rel="nofollow" href="http://www.atguigu.com">服务条款</a> | <a rel="nofollow" href="http://www.atguigu.com">免责声明</a> | <a rel="nofollow" href="http://www.atguigu.com">网站地图</a> | <a rel="nofollow" href="http://www.atguigu.com">联系我们</a>
                    </div>
                    <div class="copyRight">
                        Copyright ?2017-2017 atguigu.com 版权所有
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="${appPath }/jquery/jquery-2.1.1.min.js"></script>
    <script src="${appPath }/bootstrap/js/bootstrap.min.js"></script>
    <script src="${appPath }/script/docs.min.js"></script>
    <script src="${appPath }/script/layer/layer.js"></script>
    <script src="${appPath }/jquery/jquery-form.min.js"></script>
    <script>
        $(function() {
	        $('#myTab a').click(function (e) {
	          e.preventDefault()
	          $(this).tab('show')
	        });
	        $("#uploadCertForm :file").change(function(event) {// 图片预览效果
	        	var files = event.target.files;
	            var file;

	            if (files && files.length > 0) {
	                file = files[0];

	                var URL = window.URL || window.webkitURL;
	                // 本地图片路径
	                var imgURL = URL.createObjectURL(file);

	                var imgObj = $(this).next(); //获取同辈紧邻的下一个元素
	                // console.log(imgObj);
	                imgObj.attr("src", imgURL);
	                imgObj.show();
	            }

	        });

	        $("#prevBtn").click(function() {
	        	
	        });

	        $("#nextBtn").click(function() {
	        	var jsonData = {};

	        	var loadingIndex = -1;
	        	var options = {
	        		"url" : "${appPath}/member/uploadCertFile.do",
	        		beforeSubmit : function() {
                        loadingIndex = layer.load(2, {time:3*1000});
                    },
                    success : function(result) {
                        layer.close(loadingIndex);
                        if (result.success) {
                            $("#uploadCertForm")[0].reset();
                            layer.msg("成功上传所需资质文件!", {time : 1000, icon:6, shift:6}, function() {
	                            window.location.href = "${appPath}/member/apply.htm";
                            });
                        } else {
                        	layer.msg("上传所需资质文件失败!", {time : 1000, icon:5, shift:6});
                        }
                    }
	        	};
	        	$("#uploadCertForm").ajaxSubmit(options);
	        });
        });
    </script>
  </body>
</html>