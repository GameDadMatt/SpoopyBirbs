// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

////////////////////////////////////////////
// CameraFilterPack - by VETASOFT 2020 /////
////////////////////////////////////////////

Shader "CameraFilterPack/Drawing_CellShading2" {
Properties 
{
_MainTex ("Base (RGB)", 2D) = "white" {}
_TimeX ("Time", Range(0.0, 1.0)) = 1.0
_Distortion ("_Distortion", Range(0.0, 1.0)) = 0.3
_ScreenResolution ("_ScreenResolution", Vector) = (0.,0.,0.,0.)
_EdgeSize ("_EdgeSize", Range(0.0, 1.0)) = 0
_ColorLevel ("_ColorLevel", Range(0.0, 10.0)) = 7
}
SubShader 
{
Pass
{
Cull Off ZWrite Off ZTest Always
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma fragmentoption ARB_precision_hint_fastest
#pragma target 3.0
#pragma glsl
#include "UnityCG.cginc"

uniform sampler2D _MainTex;
uniform float _TimeX;
uniform float _Distortion;
uniform float4 _ScreenResolution;
uniform float _EdgeSize;
uniform float _ColorLevel;

struct appdata_t
{
float4 vertex   : POSITION;
float4 color    : COLOR;
float2 texcoord : TEXCOORD0;
};

struct v2f
{
float2 texcoord  : TEXCOORD0;
float4 vertex   : SV_POSITION;
float4 color    : COLOR;
};   

v2f vert(appdata_t IN)
{
v2f OUT;
OUT.vertex = UnityObjectToClipPos(IN.vertex);
OUT.texcoord = IN.texcoord;
OUT.color = IN.color;

return OUT;
}


float4 edgeFilter(in int px, in int py, float2 uvst) 
{

float4 color = float4(0, 0, 0, 0);

color += tex2D(_MainTex, ((uvst.xy*_ScreenResolution.xy) + float2(px + 1, py + 1)) / _ScreenResolution.xy);
color += tex2D(_MainTex, ((uvst.xy*_ScreenResolution.xy) + float2(px + 1, py + 0)) / _ScreenResolution.xy);
color += tex2D(_MainTex, ((uvst.xy*_ScreenResolution.xy) + float2(px + 1, py + -1)) / _ScreenResolution.xy);
color += tex2D(_MainTex, ((uvst.xy*_ScreenResolution.xy) + float2(px + 0, py + 1)) / _ScreenResolution.xy);
color += tex2D(_MainTex, ((uvst.xy*_ScreenResolution.xy) + float2(px + 0, py + 0)) / _ScreenResolution.xy);
color += tex2D(_MainTex, ((uvst.xy*_ScreenResolution.xy) + float2(px + 0, py + -1)) / _ScreenResolution.xy);
color += tex2D(_MainTex, ((uvst.xy*_ScreenResolution.xy) + float2(px + -1, py + 1)) / _ScreenResolution.xy);
color += tex2D(_MainTex, ((uvst.xy*_ScreenResolution.xy) + float2(px + -1, py + 0)) / _ScreenResolution.xy);
color += tex2D(_MainTex, ((uvst.xy*_ScreenResolution.xy) + float2(px + -1, py + -1)) / _ScreenResolution.xy);


return color / 9.0;

}


half4 _MainTex_ST;
float4 frag(v2f i) : COLOR
{
float2 uvst = UnityStereoScreenSpaceUVAdjust(i.texcoord, _MainTex_ST);

float kernel[6];
float3 final_colour = float3(0,0,0);

kernel[0]=0;
kernel[1]=0;
kernel[2]=0;
kernel[3]=0;
kernel[4]=0;
kernel[5]=0;

float Z = 0.0;
for (int j = 0; j <= 2; ++j)
{
kernel[2+j] = kernel[2-j] = 0.4;
}

for (int j = 0; j < 6; ++j)
{
Z += kernel[j];
}

for (int u=-2; u <= 2; ++u)
{
for (int j=-2; j <= 2; ++j)
{
float kernelmult = kernel[2+j] * kernel[2+u];
float4 tex = tex2D(_MainTex, (uvst.xy * _ScreenResolution.xy + float2(float(u*_Distortion*2),float(j*_Distortion*2))) / _ScreenResolution.xy);
final_colour +=  kernelmult * (tex).rgb;
}
}

float4 rgbx=float4(final_colour/(Z*Z),1.0);


float4 color = float4(0, 0, 0, 0);

color += tex2D(_MainTex, ((uvst.xy*_ScreenResolution.xy) + float2(1, 1)) / _ScreenResolution.xy);
color += tex2D(_MainTex, ((uvst.xy*_ScreenResolution.xy) + float2(1, 0)) / _ScreenResolution.xy);
color += tex2D(_MainTex, ((uvst.xy*_ScreenResolution.xy) + float2(1, -1)) / _ScreenResolution.xy);
color += tex2D(_MainTex, ((uvst.xy*_ScreenResolution.xy) + float2(0, 1)) / _ScreenResolution.xy);
color += tex2D(_MainTex, ((uvst.xy*_ScreenResolution.xy) + float2(0, 0)) / _ScreenResolution.xy);
color += tex2D(_MainTex, ((uvst.xy*_ScreenResolution.xy) + float2(0, -1)) / _ScreenResolution.xy);
color += tex2D(_MainTex, ((uvst.xy*_ScreenResolution.xy) + float2(-1, 1)) / _ScreenResolution.xy);
color += tex2D(_MainTex, ((uvst.xy*_ScreenResolution.xy) + float2(-1, 0)) / _ScreenResolution.xy);
color += tex2D(_MainTex, ((uvst.xy*_ScreenResolution.xy) + float2(-1, -1)) / _ScreenResolution.xy);


color /= 9.0;


color = floor(7.0 * color) / _ColorLevel;

float4 sum = abs(edgeFilter(0, 1, uvst) - edgeFilter(0, -1, uvst));
sum += abs(edgeFilter(1, 0, uvst) - edgeFilter(-1, 0, uvst));
sum /= 2.0;

color =lerp(color, rgbx*2.0,_Distortion);

float edgsum = _EdgeSize + 0.05;
if(length(sum) > edgsum) {
color.rgb = 0.0;
}
return color;	
}

ENDCG
}

}
}