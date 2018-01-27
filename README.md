# CourseSelect [![Build Status](https://travis-ci.org/PENGZhaoqing/CourseSelect.svg?branch=master)](https://travis-ci.org/PENGZhaoqing/CourseSelect)

### [中文教程1](http://blog.csdn.net/ppp8300885/article/details/52594839) [中文教程2](http://blog.csdn.net/ppp8300885/article/details/52601560) [中文教程3](http://blog.csdn.net/ppp8300885/article/details/52669749)


这个样本系统是基于国科大研究生课程 (高级软件工程) 开发的项目,目的是帮助入门者学习RoR (Ruby on Rails) 

适合新学者的入手的第一个项目 ([演示Demo戳这里](https://courseselect.herokuapp.com/ ))，入门者可以在这个样本系统上增加更多的功能:

* 处理选课冲突、控制选课人数
* 统计选课学分，学位课等
* 增加选课的开放、关闭功能
* 自定义管理员后台
* 基于OAuth的授权登陆
* Excel格式的数据导入
* 绑定用户邮箱（实现注册激活，忘记密码等）
* 站内查找检索 （课程按分类查找，过滤等）

### 目前功能：

* 多角色登陆（学生，老师，管理员）
* 学生动态选课，退课
* 老师动态增加，删除课程
* 老师对课程下的学生添加、修改成绩
* 权限控制：老师和学生只能看到自己相关课程信息


## 使用

1.学生登陆：

账号：`student1@test.com`

密码：`password`

2.老师登陆：

账号：`teacher1@test.com`

密码：`password`


3.管理员登陆：

账号：`admin@test.com`

密码：`password`

账号中数字都可以替换成2,3...等等


## Heroku云部署

项目可直接在Heroku上免费部署




