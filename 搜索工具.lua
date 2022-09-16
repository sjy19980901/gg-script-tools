function exit()
  print("结束脚本")
  os.exit()
end

function init()
  -- 数据类型
  DWORD = gg.TYPE_DWORD
  DOUBLE = gg.TYPE_DOUBLE
  FLOAT = gg.TYPE_FLOAT
  WORD = gg.TYPE_WORD
  BYTE = gg.TYPE_BYTE
  XOR = gg.TYPE_XOR
  QWORD = gg.TYPE_QWORD

  -- 内存类型
  Ca = gg.REGION_C_ALLOC
  Ch = gg.REGION_C_HEAP
  Jh = gg.REGION_JAVA_HEAP
  Cd = gg.REGION_C_DATA
  Cb = gg.REGION_C_BSS
  PS = gg.REGION_PPSSPP
  A = gg.REGION_ANONYMOUS
  J = gg.REGION_JAVA
  S = gg.REGION_STACK
  As = gg.REGION_ASHMEM
  O = gg.REGION_OTHER
  B = gg.REGION_BAD
  Xa = gg.REGION_CODE_APP
  Xs = gg.REGION_CODE_SYS

  maxCount = 9999999;
end

function main()
  gg.showUiButton()
  while true do
    if gg.isClickedUiButton() then
      local idx = gg.choice({
        '快速找到唯一地址(二分法)'
      })
      if idx ~= nil then
        runItemOne(idx);
      end
    end
    gg.sleep(200)
  end
end





--快速找到唯一地址(二分法)
function item01()
  local idx = gg.choice({
    '自动版'
  })
  if idx ~= nil then
    runItemTwo(idx,"01");
  end
end


--快速找到唯一地址(二分法自动版)
function item0101()
  if gg.getResultsCount() == 0 then
    gg.alert("请先搜索出所有可能的结果!");
    return;
  end

  local rTable = gg.prompt(
          {'改变数值',"恢复数值","测试停留时间(秒)"},
          {},
          {[1]='number',[2]='number',[3]='number'}
  );

  if rTable == nil or rTable[1] == nil or rTable[2] == nil or rTable[3] == nil then
    gg.alert("改变数值或恢复数据或测试停留时间不能为空!");
    return;
  end

  if tonumber(rTable[3]) < 5 then
    gg.alert("测试停留时间必须大于5秒!");
    return;
  end

  local editValue = rTable[1];
  local discoverValue = rTable[2];
  local sleepTime = rTable[3] * 1000;


  local saveResults = {};
  local editHalfTable;
  while (getResults(saveResults) > 1) do
    editHalfTable = changeHalf(saveResults,editValue);
    gg.toast("请开始测试!");
    gg.sleep(sleepTime - 3000);
    gg.toast("3秒后将出现提示,请尽快结束测试!");
    gg.sleep(3000);
    local tResult = gg.alert("当前修改值是否产生效果?","否","是");
    if tResult == 1 then
      --没有效果
      saveResults = afterNoChangeResults(#editHalfTable);
    else
      --有效果
      saveResults = afterChangeResults(saveResults,#editHalfTable,discoverValue);
    end
  end
end

--快速找到唯一地址(二分法手动版)
function item0102()
  if gg.getResultsCount() == 0 then
    gg.alert("请先搜索出所有可能的结果!");
    return;
  end

  local rTable = gg.prompt(
          {'改变数值',"恢复数值","测试停留时间(秒)"},
          {},
          {[1]='number',[2]='number',[3]='number'}
  );

  if rTable == nil or rTable[1] == nil or rTable[2] == nil or rTable[3] == nil then
    gg.alert("改变数值或恢复数据或测试停留时间不能为空!");
    return;
  end
  local editValue = rTable[1];
  local discoverValue = rTable[2];
  local sleepTime = rTable[3] * 1000;


  local saveResults;
  local editHalfTable;
  while (getResults(saveResults) > 1) do
    editHalfTable = changeHalf(saveResults,editValue);
    gg.sleep(sleepTime);
    local tResult = gg.alert("当前修改值是否产生效果?","否","是");
    if tResult == 1 then
      --没有效果
      saveResults = afterNoChangeResults(#editHalfTable);
    else
      --有效果
      saveResults = afterChangeResults(saveResults,#editHalfTable,discoverValue);
    end
  end
end


--产生效果后续
function afterChangeResults(searchResults,editCount,discoverValue)
  local deleteResults = gg.getResults(#searchResults,editCount);
  gg.removeResults(deleteResults);
  gg.toast("移除无用的结果集,数量为:"..#deleteResults);
  local editResults = gg.getResults(maxCount);
  for i = 1,#editResults do
    editResults[i]["value"] = discoverValue;
  end
  gg.setValues(editResults);
  gg.toast("恢复剩下需要修改的结果集,数量为:"..#editResults);
  return gg.getResults(maxCount);
end

--没有产生效果后续
function afterNoChangeResults(editCount)
  local deleteResults = gg.getResults(editCount);
  gg.removeResults(deleteResults);
  gg.toast("移除无用的结果集,数量为:"..#deleteResults);
  return gg.getResults(maxCount);
end



--改变一半的数值
function changeHalf(searchResults,editValue)
  searchResults = gg.getResults(maxCount);
  gg.toast("查询结果数量:"..#searchResults..",\r\n修改值:"..editValue);
  gg.sleep(1000);
  local changeTable = {};
  local count = #searchResults;
  local m = count % 2
  local halfCount = 0
  if m ~= 0 then
    halfCount = count / 2 + 1;
  else
    halfCount = count / 2;
  end
  changeTable = gg.getResults(halfCount);
  for i = 1,halfCount do
    changeTable[i]["value"] = editValue;
  end
  gg.setValues(changeTable);
  gg.toast("共修改"..halfCount.."条数据,修改值为:"..editValue);
  return changeTable;
end




--获取gg的搜索结果
function getResults(results)
  results = gg.getResults(maxCount);
  local count = #results;
  gg.toast("剩余结果长度为:"..count);
  return count;
end



function item02()

end



-- 自动调用一级方法
function runItemOne(index)
  local iStr = index < 10 and "0" .. index or tostring(index);
  local str = "item" .. iStr .. "()" ;
  load(str)();
end

-- 自动调用二级方法
function runItemTwo(index,firstNum)
  local iStr = index < 10 and "0" .. index or tostring(index);
  local str = "item" .. firstNum .. iStr .. "()" ;
  load(str)();
end

init();
main();