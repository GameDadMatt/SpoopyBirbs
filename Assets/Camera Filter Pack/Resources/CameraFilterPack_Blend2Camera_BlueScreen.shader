// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

////////////////////////////////////////////
// CameraFilterPack - by VETASOFT 2020 /////
////////////////////////////////////////////

Shader "CameraFilterPack/Blend2Camera_BlueScreen" { 
Properties 
{
_MainTex ("Base (RGB)", 2D) = "white" {}
_MainTex2 ("Base (RGB)", 2D) = "white" {}
_TimeX ("Time", Range(0.0, 1.0)) = 1.0
_ScreenResolution ("_ScreenResolution", Vector) = (0.,0.,0.,0.)
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
uniform sampler2D _MainTex2;
uniform float _TimeX;
uniform float _Value;
uniform float _Value2;
uniform float _Value3;
uniform float _Value4;
uniform float _Value5;
uniform float _Value6;
uniform float _Value7;
uniform float4 _ScreenResolution;
uniform float2 _MainTex_TexelSize;

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

float4 bluescreen( float3 s, float3 d )
{

float maxrb = max( d.r, d.g );
float k = clamp( (d.b-maxrb-_Value3)*3.0, 0.0, 1.0 );
float dg = d.b; 
d.b = min( d.b-_Value2, maxrb*0.8 ); 
d += dg - d.b-_Value4;
d.r+=_Value5;
d.b+=_Value6;
d.g+=_Value7;
float3 result = lerp(d, s, k);
return  float4( result, 1.0 );
}

half4 _MainTex_ST;
float4 frag(v2f i) : COLOR
{
float2 uvst = UnityStereoScreenSpaceUVAdjust(i.texcoord, _MainTex_ST);
float2 uv=uvst.xy;
float4 tex = tex2D(_MainTex,uv);
#if UNITY_UV_STARTS_AT_TOP
if (_MainTex_TexelSize.y < 0)
uv.y = 1-uv.y;
#endif
float4 tex2 = tex2D(_MainTex2,uv);
tex=lerp(tex, bluescreen(tex,tex2),_Value);
return  float4(tex.rgb,1.0);
}
ENDCG
}
}
}
