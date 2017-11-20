<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="security"
	   uri="http://www.springframework.org/security/tags" %>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="../css/jquery.steps.css" />
        <link rel="stylesheet" href="../css/jquery.steps.custom.css" />
        <link href="../css/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link href="../css/jtables-bdre.css" rel="stylesheet" type="text/css" />
        <link href="../css/jquery-ui-1.10.3.custom.css" rel="stylesheet" type="text/css" />
        <link href="../css/bootstrap.custom.css" rel="stylesheet" />
        <link href="../StreamAnalytix_files/materialdesignicons.min.css" media="all" rel="stylesheet" type="text/css">
        <link href="../StreamAnalytix_files/bootstrap.min.css" rel="stylesheet">
        <link href="../StreamAnalytix_files/bootstrap-material-design.min.css" rel="stylesheet">
        <link href="../StreamAnalytix_files/ripples.min.css" rel="stylesheet">
        <link href="../StreamAnalytix_files/sax-fonts.css" class="include" rel="stylesheet" type="text/css">
        <link href="../StreamAnalytix_files/toastr.min.css" rel="stylesheet">
        <link href="../StreamAnalytix_files/datatables.min.css" rel="stylesheet">
        <link href="../StreamAnalytix_files/theme.css" rel="stylesheet" type="text/css">
        <link href="../StreamAnalytix_files/style.css" rel="stylesheet" type="text/css">
        <link href="../StreamAnalytix_files/select2.4.0.css" rel="stylesheet">
        <link href="../StreamAnalytix_files/select2-bootstrap.css" rel="stylesheet">
        <script src="../js/jquery.min.js" type="text/javascript"></script>
        <script src="../js/jquery-ui-1.10.3.custom.js" type="text/javascript"></script>
        <script src="../js/jquery.steps.min.js" type="text/javascript"></script>
        <script src="../js/jquery.jtable.js" type="text/javascript"></script>
        <script src="../js/bootstrap.js" type="text/javascript"></script>
        <script src="../js/angular.min.js" type="text/javascript"></script>

         <link href="../css/select2.min.css" rel="stylesheet" />
                        <script src="../js/select2.min.js"></script>


    </head>
    <body>

    <script>
    var aggregationFinal ="";
                   var intercept="";
           var columns =[];
           var map2=new Map();
    		var insert=1;
         var wizard = null;
         var finalJson;
         wizard = $(document).ready(function() {

    	$("#bdre-data-load").steps({
    		headerTag: "h2",
    		bodyTag: "section",
    		transitionEffect: "slideLeft",
    		stepsOrientation: "vertical",
    		enableCancelButton: true,
    		onStepChanging: function(event, currentIndex, newIndex) {
    			console.log(currentIndex + 'current ' + newIndex );

    		   if(currentIndex==4 && newIndex==5)
    		   	{

                   var x = '';
                   x = document.getElementById("modelData");
                   console.log(x);
                   var text = "";
                   var i;
                   if(x.length>2){
                   for(i = 0; i < x.length; i=i+2) {
                         var column=x.elements[i].value;
                         var val=x.elements[i+1].value;
                         if(i==0)
                         {
                          intercept=x.elements[i+2].value;
                          i=i+1;
                          console.log("intercept is "+intercept);
                         }
                         if(val != "0" || val != "")
                         text= text+column+"::"+val+",";
                   }
                   }

                   console.log(text);
                   aggregationFinal=text;

    		   	}
    		return true;
    		},
    		onStepChanged: function(event, currentIndex, priorIndex) {
    			        console.log(currentIndex + " " + priorIndex);

    			       if(priorIndex==1 && currentIndex==2){
    			        var text = $('#persistentName option:selected').text();
                            	$('#rawTableColumnDetails').jtable({
                                                        });
                                                        $('#rawTableColumnDetails').jtable('destroy');
                                                        console.log("hiiiiiiii");
                                                        console.log(text);
                                                        console.log("hiiiiiiii");
                                                          if(text=="HDFS"){
                                                        console.log(text);
                                                        	$('#rawTableColumnDetails').jtable({
                                                        		title: 'Schema column details',
                                                        		paging: false,
                                                        		sorting: false,
                                                        		create: false,
                                                        		edit: false,
                                                        		actions: {

                                                                    listAction: function(postData){
                                                                    },
                                                        			createAction: function(postData) {
                                                                        console.log(postData);
                                                                        var serialnumber = 1;
                                                                        var rawSplitedPostData = postData.split("&");
                                                                        var rawJSONedPostData = '{';
                                                                        rawJSONedPostData += '"serialNumber":"';
                                                                        rawJSONedPostData += serialnumber;
                                                                        serialnumber += 1;
                                                                        rawJSONedPostData += '"';
                                                                        rawJSONedPostData += ',';
                                                                        for (i=0; i < rawSplitedPostData.length ; i++)
                                                                        {
                                                                            console.log("data is " + rawSplitedPostData[i]);
                                                                            rawJSONedPostData += '"';
                                                                            rawJSONedPostData += rawSplitedPostData[i].split("=")[0];
                                                                            rawJSONedPostData += '"';
                                                                            rawJSONedPostData += ":";
                                                                            rawJSONedPostData += '"';
                                                                            rawJSONedPostData += rawSplitedPostData[i].split("=")[1];
                                                                            rawJSONedPostData += '"';
                                                                            rawJSONedPostData += ',';
                                                                            console.log("json is" + rawJSONedPostData);
                                                                        }
                                                                        var rawLastIndex = rawJSONedPostData.lastIndexOf(",");
                                                                        rawJSONedPostData = rawJSONedPostData.substring(0,rawLastIndex);
                                                                        rawJSONedPostData +=  "}";
                                                                        console.log(rawJSONedPostData);


                                                                       var rawReturnObj='{"Result":"OK","Record":' + rawJSONedPostData + '}';
                                                                       var rawJSONedReturn = $.parseJSON(rawReturnObj);

                                                                       return $.Deferred(function($dfd) {
                                                                                        console.log(rawJSONedReturn);
                                                                                        $dfd.resolve(rawJSONedReturn);
                                                                                    });

                                                        				}


                                                        		},

                                                        		fields: {
                                                        		    serialNumber:{
                                                        		        key : true,
                                                        		        list:false,
                                                        		        create : false,
                                                        		        edit:false
                                                        		    },
                                                        			columnName: {
                                                        				title: '<spring:message code="dataload.page.title_col_name"/>',
                                                        				width: '50%',
                                                        				edit: true,
                                                        				create:true
                                                        			},
                                                        			dataType: {

                                                        				create: true,
                                                        				title: 'Data Type',
                                                        				edit: true,
                                                        				options:{ 'String':'String',
                                                                                  'Integer':'Integer',
                                                                                  'Long':'Long',
                                                                                  'Short':'Short',
                                                                                  'Byte':'Byte',
                                                                                  'Float':'Float',
                                                                                  'Double':'Double',
                                                                                  'Decimal':'Decimal',
                                                                                  'Boolean':'Boolean',
                                                                                  'Decimal':'Decimal',
                                                                                  'Binary' : 'Binary',
                                                                                  'Date':'Date',
                                                                                  'TimeStamp':'TimeStamp'
                                                                                  }
                                                        			}
                                                        		}

                                                        	});
                                                        	console.log($('#rawTableColumnDetails'));
                                                        	$('#rawTableColumnDetails').jtable('load');
                                                        	console.log($('#rawTableColumnDetails'));

                                                        }
                                                        else if(text=="Hive")
                                                        {
                                                             console.log(text);
                                                             var srcDb=document.getElementById("dbName").value;
                                                             var tbl=document.getElementById("tblName").value;
                                                             var srenv="localhost:10000";
                                                             console.log(srcDb);
                                                             console.log(tbl);
                                                             console.log("i think this will work");
                                                             $('#rawTableColumnDetails').jtable({
                                                             title: 'Hive column details',
                                                             actions: {
                                                               listAction: function(postData){
                                                               return $.Deferred(function ($dfd) {
                                                               $.ajax({

                                                                 url: "/mdrest/ml/columns/" + srenv + '/' + srcDb + '/' + tbl,
                                                                     type: 'GET',
                                                                     dataType: 'json',
                                                                     async: false,
                                                                     success: function (data) {
                                                                         var hiveColumns=data.Records;
                                                                         console.log(hiveColumns);

                                                                         for(var k in hiveColumns) {

                                                                                     console.log(hiveColumns[k].columnName);
                                                                                     columns.push(hiveColumns[k].columnName);

                                                                             }
                                                                         $dfd.resolve(data);

                                                                     },
                                                                     error: function () {
                                                                         alert('danger');
                                                                     }
                                                                 });
                                                                 });
                                                              },
                                                             updateAction: function(postData) {


                                                                                      }
                                                                                      },
                                                fields: {

                                                                    columnName: {
                                                                        title: '<spring:message code="dataload.page.title_col_name"/>',
                                                                        width: '50%',
                                                                        edit: true,
                                                                        create:true,
                                                                        list:true,
                                                                        key:true
                                                                    },
                                                                    dataType: {

                                                                        create: true,
                                                                        title: 'Data Type',
                                                                        edit: true,
                                                                        list:true,
                                                                        key:false

                                                                    }

                                                                }
                                                             });
                                                             console.log("i think this will work");

                                                             $('#rawTableColumnDetails').jtable('load');


                                                        }
                                                        else
                                                        {
                                                           console.log(text);
                                                           $('#rawTableColumnDetails').jtable({
                                                                                        title: 'HBase column details',
                                                                                        });
                                                                                        console.log($('#rawTableColumnDetails'));
                                                                                        $('#rawTableColumnDetails').jtable('load');
                                                                                        console.log($('#rawTableColumnDetails'));
                                                        }

                          }
    		},
    		onFinished: function(event, currentIndex) {

    		},
    		onCanceled: function(event) {

    		}
    	});
    });

    		</script>
<script>

</script>
  <script>
  var map = new Object();
  function formIntoMap(typeProp, typeOf) {
  	var x = '';
  	x = document.getElementById(typeOf);
  	console.log(x);
  	var text = "";
  	var i;
  	for(i = 0; i < x.length; i++) {
  		map[typeProp + x.elements[i].name] = x.elements[i].value;
  		//console.log(map[typeProp + x.elements[i].name]);
  		//console.log(x.elements[i].value);
  	}

  }

  function messageChange()
                                 {

                                 console.log("function messageChange is being called");
                                 var message=document.getElementById("messageName").value;

                                 console.log("value of messageName is "+message);
                               angular.element(document.getElementById('preMessageDetails')).scope().change(message);



                                 }
  </script>
  <script>
                  var app = angular.module('app', []);
                     app.controller('myCtrl',function($scope) {


                      $scope.modelList={};
                      $scope.persistentList={};


                      $scope.columnList={};

                        $scope.processId=86;

                     $.ajax({

                         url: "/mdrest/processtype/options_analytics/"+$scope.processId,

                             type: 'POST',
                             dataType: 'json',
                             async: false,
                             success: function (data) {

                                 $scope.modelList = data.Options;
                                 console.log($scope.modelList);
                             },
                             error: function () {
                                 alert('danger');
                             }
                         });
                         $.ajax({
                         url: "/mdrest/genconfig/PersistentStores_Connection_Type/?required=2",
                         type: 'POST',
                          dataType: 'json',
                          async: false,
                          success: function (data) {
                          $scope.persistentList = data.Records;
                                                           console.log("hiiii");
                                                           console.log($scope.persistentList);
                                                           console.log("hiiii");
                          },
                                                       error: function () {
                                                           alert('danger');
                                                       }
                         });



                  });
                   function saveModelProperties(){

                                             console.log("saveModelProperties is being called");
                                           formIntoMap("Model_","modelConfirmation");
                                                                                       formIntoMap("ModelProperties_","persistentStore");
                                                                                       formIntoMap("ModelProperties_","persistentFieldsForm");
                                                                                       formIntoMap("ModelProperties_","modelDetail");
                                                                                       var text2 = $('#loadOptions option:selected').text();
                                                                                       console.log("THis is ksjdkjwdkjkd");
                                                                                       console.log(text2);
                                                                                       if(text2=="PMML File" || text2=="Serialized Model"){
                                                                                       formIntoMap("ModelProperties_","modelData");
                                                                                       }
                                                                                       else{
                                                                                            var features=aggregationFinal.slice(0,aggregationFinal.length-1);
                                                                                            map["ModelProperties_features"]=features;
                                                                                            map["ModelProperties_intercept"]=intercept;
                                                                                       }
                                                                                       map["ModelProperties_features"]=features;
                                                                                       map["ModelProperties_intercept"]=intercept;

                                                                                       console.log("hiiii");
                                                                                       jtableIntoMap("", "rawTableColumnDetails");
                                                                                        var columns="";
                                                                                        var i=0;
                                                                                        var key1=Object.keys(map1)[0];
                                                                                        console.log(key1);
                                                                                       for(i=0;i<map1.length;i++){
                                                                                       var key=Object.keys(map1)[i];
                                                                                       var value=map1[key];
                                                                                       console.log("hiiiiiooooooo");
                                                                                       console.log(key);
                                                                                        console.log("hiiiiiooooooooo");
                                                                                           columns.concat(key);
                                                                                           columns.concat(":");
                                                                                           columns.concat(value);
                                                                                           if(i<map1.length-1)
                                                                                           columns.concat(",");

                                                                                       }

                                                                                       console.log("Bhuvi bowled well today");
                                                                                       map["ModelProperties_Columns"]=columns;



                                                                                       console.log(map);
                                             $.ajax({
                                                         type: "POST",
                                                         url: "/mdrest/ml/createjobs/",
                                                         data: jQuery.param(map),
                                                         success: function(data) {
                                                             if(data.Result == "OK") {

                                                                 alert("Job Created Successfully");

                                               }

                                                             else{
                                                             alert("warning","Error occured");
                                                             }
                                                         }

                                                     });
                                             }

                    function uploadZip (subDir,fileId){
                                 var arg= [subDir,fileId];
                                   var fd = new FormData();
                                  		                var fileObj = $("#"+arg[1])[0].files[0];
                                                          var fileName=fileObj.name;
                                                          fd.append("file", fileObj);
                                                          fd.append("name", fileName);
                                                          $.ajax({
                                                            url: '/mdrest/filehandler/uploadzip/'+arg[0],
                                                            type: "POST",
                                                            data: fd,
                                                            async: false,
                                                            enctype: 'multipart/form-data',
                                                            processData: false,  // tell jQuery not to process the data
                                                            contentType: false,  // tell jQuery not to set contentType
                                                            success:function (data) {
                                                                  uploadedFileName=data.Record.fileName;
                                                                  console.log( data );
                                                                  $("#div-dialog-warning").dialog({
                                                                                  title: "",
                                                                                  resizable: false,
                                                                                  height: 'auto',
                                                                                  modal: true,
                                                                                  buttons: {
                                                                                      "Ok" : function () {
                                                                                          $(this).dialog("close");
                                                                                      }
                                                                                  }
                                                                  }).html('<p><span class="jtable-confirm-message"><spring:message code="processimportwizard.page.upload_success"/>'+' ' + uploadedFileName + '</span></p>');
                                                                  return false;
                                  							},
                                  						  error: function () {
                                  							    $("#div-dialog-warning").dialog({
                                                                              title: "",
                                                                              resizable: false,
                                                                              height: 'auto',
                                                                              modal: true,
                                                                              buttons: {
                                                                                  "Ok" : function () {
                                                                                      $(this).dialog("close");
                                                                                  }
                                                                              }
                                                              }).html('<p><span class="jtable-confirm-message"><spring:message code="processimportwizard.page.upload_error"/></span></p>');
                                                              return false;
                                  							}
                                  						 });

                                  }





          </script>
          <script>
          function loadModelProperties(loadMethod) {
              console.log(loadMethod);
                      if(loadMethod=="serializedModel" || loadMethod=="pmmlFile"){
                      var div = document.getElementById('modelRequiredFields');
                      var formHTML='';
                      formHTML=formHTML+'<form class="form-horizontal" role="form" id="modelData">';
                      formHTML=formHTML+'<div id="rawTablDetailsDB">';
                      formHTML=formHTML+'<div class="form-group" >';
                      formHTML=formHTML+'<label class="control-label col-sm-2" for="regFile">Model File</label>';
                      formHTML=formHTML+'<div class="col-sm-10">';
                      formHTML=formHTML+'<input name = "regFile" id = "regFile" type = "file" class = "form-control" style="opacity: 100; position: inherit;" />';
                      formHTML=formHTML+'</div>';
                      formHTML=formHTML+'</div>';
                      formHTML=formHTML+'<button class = "btn btn-default  btn-success" style="margin-top: 30px;background: lightsteelblue;" type = "button" onClick = "uploadZip(\''+"model"+'\',\''+"regFile"+'\')" href = "#" >Upload File</button >';
                      formHTML=formHTML+'<div class="clearfix"></div>';
                      formHTML=formHTML+'</div>';
                      formHTML=formHTML+'</form>';
                      div.innerHTML = formHTML;
                      }
                      else{
                      console.log("do nothing");
                      var div = document.getElementById('modelRequiredFields');
                      var formHTML='';
                       var next=1;
                        formHTML=formHTML+'<div class="form-group col-md-12" >';
                       formHTML=formHTML+'<div class="col-md-4">Column </div>';
                       formHTML=formHTML+'<div class="col-md-4">Coefficient</div>';
                       formHTML=formHTML+'<div class="col-md-4">Intercept</div>';
                        formHTML=formHTML+'</div>';
                      formHTML=formHTML+'<form class="form-horizontal" role="form" id="modelData">';

                       for(var t=0;t<columns.length;t++){
                       formHTML=formHTML+'<div class="form-group col-md-12" >';
                       formHTML = formHTML +  '<div class="col-md-4">' ;
                       formHTML = formHTML +  '<input class="form-control" id="column.' + next + '" value='+ columns[t] +' name="column.' + next + '">' ;
                       formHTML = formHTML +  '</input>' ;
                       formHTML = formHTML +  '</div>' ;
                       formHTML = formHTML +  '<div class="col-md-4">' ;
                       formHTML = formHTML +  '<input class="form-control" id="Coefficient.' + next + '"value='+ 0 +' name="Coefficient.' + next + '">' ;
                       formHTML = formHTML +  '</input>' ;
                       formHTML = formHTML +  '</div>' ;

                       if(t==0){
                       formHTML = formHTML +  '<div class="col-md-4">' ;
                       formHTML = formHTML +  '<input class="form-control" id="Intercept.' + next + '"value='+ 0 +' name="Intercept.' + next + '">' ;
                       formHTML = formHTML +  '</input>' ;
                       formHTML = formHTML +  '</div>' ;
                       formHTML=formHTML+'</div>';
                       }
                       else
                       {
                       formHTML = formHTML +  '<div class="col-md-4">' ;
                       //formHTML = formHTML +  '<input class="form-control" id="Intercept.' + next + '"value='+ 0 +' name="Intercept.' + next + '">' ;
                       //formHTML = formHTML +  '</input>' ;
                        formHTML = formHTML +  '</div>' ;
                       formHTML=formHTML+'</div>';
                       }
                       next++;
                       }
                        formHTML=formHTML+'<div class="clearfix"></div>';
                        formHTML=formHTML+'</form>';
                       div.innerHTML = formHTML;

                      }}
          </script>


  <div  ng-app="app" id="preModelDetails" ng-controller="myCtrl">




  	<div id="bdre-data-load">

<h2><div class="number-circular">1</div>Select type of Persistent Store Type</h2>
                        			<section>
                    <form class="form-horizontal" role="form" id="persistentStore">
                    <div class="form-group" >
                                  <label class="control-label col-sm-2" for="persistentName">Persistent Store</label>
                                  <div class="col-sm-10">
                                   <select class="form-control" id="persistentName" name="persistentName"  ng-model="persistentName"  onchange="loadProperties();" ng-options = "val.columnName as val.columnName for (file, val) in persistentList track by val.columnName"  >
                                               <option  value="">Select the option</option>
                                           </select>
                                  </div>
                              </div>

                              </form>
                              </section>

  <h2><div class="number-circular">2</div>Persistent Store Configuration Type</h2>
                          			<section>

                       <div id="persistentFields"></div>
<div class="clearfix"></div>




                                                			</section>
                                                			<h2><div class="number-circular">3</div>Data Schema</h2>
                                                			<section>
                                                			<form class="form-horizontal" role="form" id="schema">
                                                            			    <div id="rawTableColumnDetails"></div>
                                                            			    <div class="clearfix"></div>
                                                            			    </form>
                                                            			    </section>

                                                         </section>

                  <h2><div class="number-circular">4</div>Model Type</h2>
                  <section>
                  <form class="form-horizontal" role="form" id="modelDetail">

                  <div class="form-group" >
                                <label class="control-label col-sm-2" for="modelType">Model Type</label>
                                <div class="col-sm-10">
                                 <select class="form-control" id="modelType" name="modelType" ng-model = "modelName" onchange="loadModelOptions(this.value);" ng-options = "val.DisplayText as val.DisplayText for (file,val) in modelList track by val.DisplayText"   >
                                             <option  value="">Select option</option>
                                         </select>
                                </div>
                            </div>

                            <div class="form-group" >
                                <label class="control-label col-sm-2" for="loadOptions">Load Method</label>
                                <div class="col-sm-10">
                                 <select class="form-control" id="loadOptions" name="loadOptions" onchange="loadModelProperties(this.value);" >
                                             <option  value="">Select option</option>
                                         </select>
                                </div>
                            </div>

                  <div class="clearfix"></div>
                  </form>
                  </section>

                  <h2><div class="number-circular">5</div>Model Configuration</h2>
                  <section>
                        <div id="modelRequiredFields"></div>
                  </section>

                  <h2><div class="number-circular">6</div>Create Model</h2>
                  <section>
                  <form class="form-horizontal" role="form" id="modelConfirmation">
                  <div class="form-group" >
                          <label class="control-label col-sm-2" for="modelName">Model Name</label>
                          <div class="col-sm-10">
                           <input type="text" class="form-control col-sm-2"  id="modelName" name="modelName">
                          </div>
                      </div>

                   <div class="form-group" >
                         <label class="control-label col-sm-2" for="modelDescription">Model Description</label>
                         <div class="col-sm-10">
                          <input type="text" class="form-control col-sm-2"  id="modelDescription" name="modelDescription">
                         </div>
                       </div>

                       <div class="form-group" >
                            <label class="control-label col-sm-2" for="modelBusDomain">Business DomainId</label>
                            <div class="col-sm-10">
                             <input type="text" class="form-control col-sm-2"  id="modelBusDomain" name="modelBusDomain">
                            </div>
                          </div>
                   <button class = "btn btn-default  btn-success" style="margin-top: 30px;background: lightsteelblue;" type = "button" onClick = "saveModelProperties()"  >Create Job</button >
                  </form>
                  </section>


                          			<div style = "display:none" id = "div-dialog-warning" >
                                                    				<p ><span class = "ui-icon ui-icon-alert" style = "float:left;" ></span >

                                                    				</p>
                                                    				</div >

  		</div>

  </div>


  <script>
  var i=0;
  </script>
                <script>
                function loadModelTypes()
                {
                    if(i==0){
                    var processId=41;
                    $.ajax({
                        type: "POST",
                        url: "/mdrest/processtype/options_analytics/"+processId,
                        dataType: 'json',
                        success: function(data) {
                        console.log(data);
                        $.each(data.Options, function (i, v) {
                            $('#modelType').append($('<option>', {
                                value: v.value,
                                text : v.DisplayText,
                            }));
                        });
                        },
                    });
                    i=i+1;
                    }
                }


                function loadProperties() {

                    var text = $('#persistentName option:selected').text();

                        buildForm(text + "_Model_Connection", "persistentFields");

                        console.log("This is the div");


                        }
                </script>


        <script>
        function buildForm(typeOf, typeDiv) {
        	$.ajax({
        		type: "GET",
        		url: "/mdrest/genconfig/" + typeOf + "/?required=1",
        		dataType: 'json',
        		success: function(data) {
        			var root = 'Records';
        			var div = document.getElementById(typeDiv);
        			var formHTML = '';
        			formHTML = formHTML + '<form role="form" id = "' + typeDiv + 'Form">';
        			console.log(data[root]);
        			$.each(data[root], function(i, v) {
        				formHTML = formHTML + '<div class="form-group"> <label for="' + v.key + '">' + v.value + '</label>';
        				<!-- formHTML = formHTML + '<span class="glyphicon glyphicon-question-sign" title="' + v.description + '"></span>'; -->
        				formHTML = formHTML + '<input name="' + v.key + '" value="' + v.defaultVal + '" placeholder="' + v.description + '" type="' + v.type + '" class="form-control" id="' + v.key + '"></div>';
        			});
        			formHTML = formHTML + '</form>';
        			div.innerHTML = formHTML;
        			console.log(div);
        		}
        	});
        	return true;
        }
        </script>
        <script>

        function loadModelOptions(modelType){
        console.log(modelType);
        var model = modelType+"_Model";
        $.ajax({
            type: "GET",
            url: "/mdrest/genconfig/" + model + "/?required=1",
            dataType: 'json',
            success: function(data) {
            console.log(data);
            $('#loadOptions').find('option').remove();
            $.each(data.Records, function (i, v) {
                $('#loadOptions').append($('<option>', {
                    value: v.key,
                    text : v.value,
                }));
            });
            },
        });

        }

        </script>

        <script>
        var map1 = new Object();
        function jtableIntoMap(typeProp, typeDiv) {
        	var div = '';
        	div = document.getElementById(typeDiv);
        	$('div .jtable-data-row').each(function() {
        		//console.log(this);
        		$(this).addClass('jtable-row-selected');
        		$(this).addClass('ui-state-highlight');
        	});

        	var $selectedRows = $(div).jtable('selectedRows');
        	$selectedRows.each(function() {
        		var record = $(this).data('record');
        		var keys = typeProp + record.columnName;
        		//console.log(keys);
        		map1[keys] = record.dataType;
        		//console.log(map1);
        	});
        	$('.jtable-row-selected').removeClass('jtable-row-selected');
        }

        		</script>
</body>