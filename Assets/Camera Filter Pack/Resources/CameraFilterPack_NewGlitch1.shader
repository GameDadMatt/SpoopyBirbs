// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Camera Filter Pack v4.0.0                  
//                                     
// by VETASOFT 2020                    

Shader "CameraFilterPack/CameraFilterPack_NewGlitch1" {
Properties
{
_MainTex("Base (RGB)", 2D) = "white" {}
_TimeX("Time", Range(0.0, 1.0)) = 1.0
_ScreenResolution("_ScreenResolution", Vector) = (0.,0.,0.,0.)
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

uniform float _Speed;
uniform float Seed;
uniform float Size;


uniform float4 _ScreenResolution;

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



half4 _MainTex_ST;

float4 frag(v2f i) : COLOR { float4 cfresult=float4(0,0,0,0);
float2 uv = i.texcoord;
float x = uv.x;
float y = uv.y;
float glitchStrength = (Seed + 55.55)/_ScreenResolution.y * 5.0;
float psize = 0.01 + Size * glitchStrength;
float psq = 1.0 / psize;
float px = floor( x * psq + 0.5) * psize;
float py = floor( y * psq + 0.5) * psize;
float4 colSnap = tex2D( _MainTex, float2( px,py) );
float lum = pow( 1.0 - (colSnap.r + colSnap.g + colSnap.b) / 3.0, glitchStrength );
float qsize = psize * lum;
float qsq = 1.0 / qsize;
float qx = floor( x * qsq + 0.5) * qsize;
float qy = floor( y * qsq + 0.5) * qsize;
float rx = (px - qx) * lum + x;
float ry = (py - qy) * lum + y;
float4 colMove = tex2D( _MainTex, float2( rx,ry) );
cfresult = colMove;
return cfresult;}

ENDCG
}

}
} 