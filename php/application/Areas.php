<?php
/**
 * Created by PhpStorm.
 * User: Administrator
 * Date: 2017/4/12 0012
 * Time: 下午 5:30
 *
 */

/**
 * @param int $Type   获取城市数据默认1：1获取全部城市 2获取开通城市
 * @param int $Level  城市联动等级默认3：1获取省级 2获取（省/市）级 3 获取(省/市/区县)级
 * @param array $Region 需要选中的城市数据 数组格式 0省code 1市code 2区县code
 * @return string
 * 城市多级联动
 * 肖亚子
 */
function AreaLinkage($Type = 1,$Level = 3,$Region = array()){
    $ProvinceHtml = "";
    $CityHtml     = "";
    $AreaHtml     = "";

    $Province  = intval($Region[0]);
    $City      = intval($Region[1]);
    $District  = intval($Region[2]);

    if ($Type == 1){
        $ProvinceCondition["leveltype"] = 1;
    }else{
        $ProvinceCondition["leveltype"] = 1;
        $ProvinceCondition["status"] = 1;
    }

    $Arr = new \app\common\model\AreasModel();

    $RegionAreas = $Arr->RegionWhole($ProvinceCondition);

    foreach ($RegionAreas as $Key => $Val){
        $ProvinceHtml .= "<option value='{$Val['id']}'";
        if($Val['id'] == $Province){
            $ProvinceHtml .= 'selected="selected"';
        }
        $ProvinceHtml.=">{$Val['name']}</option>";
    }

    if(!empty($City)){
        if ($Type == 1){
            $CityCondition["parentid"] = $Province;
            $RegionCity = $Arr->RegionWhole($CityCondition);
        }else{
            $CityCondition["parentid"] = $Province;
            $CityCondition["status"] = 1;

            $RegionCity = $Arr->RegionWhole($CityCondition);

            $Result = array_reduce($RegionCity, function ($Result, $value) {
                $Result[] = $value["id"];
                return $Result;
            });

            $CityCondition["parentid"]   = array("in",implode(",",$Result));
            $CityCondition["city_level"] = 2;
            $CityCondition["pjstatus"]   = 1;

            $RegionCityFlat = $Arr->RegionWhole($CityCondition);
            $RegionCity     = array_merge($RegionCity,$RegionCityFlat);
        }

        foreach ($RegionCity as $Key => $Val){
            $CityHtml .= "<option value='{$Val['id']}'";
            if($Val['id'] == $City){
                $CityHtml .= 'selected="selected"';
            }
            $CityHtml.=">{$Val['name']}</option>";
        }
    }

    if(!empty($District)){
        if ($Type == 1){
            $AreaCondition["parentid"] = $City;
        }else{
            $AreaCondition["parentid"] = $City;
            $AreaCondition["pjstatus"] = 0;
        }

        $RegionArea = $Arr->RegionWhole($AreaCondition);

        foreach ($RegionArea as $Key => $Val){
            $AreaHtml .= "<option value='{$Val['id']}'";
            if($Val['id'] == $District){
                $AreaHtml .= 'selected="selected"';
            }
            $AreaHtml.=">{$Val['name']}</option>";
        }
    }
if ($Level == 1){
    $Html = <<<EOT
        <div class="layui-input-inline">
            <select name="provence_id"  lay-filter="provence_id" status="{$Type}" level="{$Level}" type="1">
                <option value="0">请选择省份</option>
               {$ProvinceHtml}
            </select>
        </div>
EOT;
}elseif ($Level == 2){
    $Html = <<<EOT
        <div class="layui-input-inline">
            <select name="provence_id"  lay-filter="provence_id" status="{$Type}" level="{$Level}" type="1">
                <option value="0">请选择省份</option>
               {$ProvinceHtml}
            </select>
        </div>
        <div class="layui-input-inline">
            <select name="city_id"  lay-filter="city_id" status="{$Type}" level="{$Level}" type="2">
                <option value="0">请选择城市</option>
               {$CityHtml}
            </select>
        </div>
EOT;
}else{
    $Html = <<<EOT
        <div class="layui-input-inline">
            <select name="provence_id"  lay-filter="provence_id" status="{$Type}" level="{$Level}" type="1">
                <option value="0">请选择省份</option>
               {$ProvinceHtml}
            </select>
        </div>
        <div class="layui-input-inline">
            <select name="city_id"  lay-filter="city_id" status="{$Type}" level="{$Level}" type="2">
                <option value="0">请选择城市</option>
               {$CityHtml}
            </select>
        </div>
        <div class="layui-input-inline">
            <select name="area_id"  lay-filter="area_id" status="{$Type}" level="{$Level}" type="3">
                <option value="0">请选择区/县</option>
               {$AreaHtml}
            </select>
        </div>
EOT;
}

    return  $Html;

}
