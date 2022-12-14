// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

////////////////////////////////////////////
// CameraFilterPack - by VETASOFT 2020 /////
////////////////////////////////////////////

Shader "CameraFilterPack/Deep_OilPaintHQ" {
Properties
{
_MainTex("Base (RGB)", 2D) = "white" {}
_TimeX("Time", Range(0.0, 1.0)) = 1.0
_Distortion("_Distortion", Range(0.0, 1.00)) = 1.0
_ScreenResolution("_ScreenResolution", Vector) = (0.,0.,0.,0.)
_ColorRGB("_ColorRGB", Color) = (1,1,1,1)

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
#include "UnityCG.cginc"


uniform sampler2D _MainTex;
uniform float _Visualize;
uniform float _TimeX;
uniform float _Distortion;
uniform float4 _ScreenResolution;
uniform float4 _ColorRGB;
uniform float _Near;
uniform float _Far;
uniform float _FarCamera;
uniform sampler2D _CameraDepthTexture;
uniform float _FixDistance;
uniform float _LightIntensity;
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
float4 color : COLOR;
float4 projPos : TEXCOORD1;
};

v2f vert(appdata_t IN)
{
v2f OUT;
OUT.vertex = UnityObjectToClipPos(IN.vertex);
OUT.texcoord = IN.texcoord;
OUT.color = IN.color;
OUT.projPos = ComputeScreenPos(OUT.vertex);

return OUT;
}

float4 efx(float2 uv)
{
float4 col = 1-tex2D(_MainTex,uv);
return col;
}


half4 _MainTex_ST;
float4 frag(v2f i) : COLOR
{
float2 uvst = UnityStereoScreenSpaceUVAdjust(i.texcoord, _MainTex_ST);
float2 uv = uvst.xy;
#if SHADER_API_D3D9
if (_MainTex_TexelSize.y < 0)
uv.y = 1 - uv.y;
#endif


float depth = LinearEyeDepth(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)).r);
depth /= _FixDistance * 10;
float ss = smoothstep(_Near, saturate(_Near + _Far), depth);
depth = ss;
if (_Visualize == 1) return depth;

float _Value = _LightIntensity*depth;
float2 src_size = float2 (_Value / _ScreenResolution.x, _Value / _ScreenResolution.y);
uv = uvst.xy;
float n = 25.;

float3 m0 = 0.0;  float3 m2 = 0.0;
float3 s0 = 0.0;  float3 s2 = 0.0;
float3 c;

c = tex2D(_MainTex, uv + float2(-4., -4.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(0, 0) * src_size).rgb; m2 += c; s2 += c * c;
c = tex2D(_MainTex, uv + float2(-3., -3.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(1, 0) * src_size).rgb; m2 += c; s2 += c * c;
c = tex2D(_MainTex, uv + float2(-2., -2.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(2, 0) * src_size).rgb; m2 += c; s2 += c * c;
c = tex2D(_MainTex, uv + float2(-1., -4.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(3, 0) * src_size).rgb; m2 += c; s2 += c * c;
c = tex2D(_MainTex, uv + float2(0., 0 - 4.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(4., 0) * src_size).rgb; m2 += c; s2 += c * c;

c = tex2D(_MainTex, uv + float2(-4., -3.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(0., 1.) * src_size).rgb; m2 += c; s2 += c * c;
c = tex2D(_MainTex, uv + float2(-3., -3.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(1., 1.) * src_size).rgb; m2 += c; s2 += c * c;
c = tex2D(_MainTex, uv + float2(-2., -3.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(2., 1.) * src_size).rgb; m2 += c; s2 += c * c;
c = tex2D(_MainTex, uv + float2(-1., -3.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(3., 1.) * src_size).rgb; m2 += c; s2 += c * c;
c = tex2D(_MainTex, uv + float2(0., -3.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(4., 1) * src_size).rgb; m2 += c; s2 += c * c;

c = tex2D(_MainTex, uv + float2(-4., -2.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(0, 2) * src_size).rgb; m2 += c; s2 += c * c;
c = tex2D(_MainTex, uv + float2(-3., -2.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(1, 2) * src_size).rgb; m2 += c; s2 += c * c;
c = tex2D(_MainTex, uv + float2(-2., -3.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(2, 2) * src_size).rgb; m2 += c; s2 += c * c;
c = tex2D(_MainTex, uv + float2(-1., -2.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(3, 2) * src_size).rgb; m2 += c; s2 += c * c;
c = tex2D(_MainTex, uv + float2(0., -2.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(4, 2) * src_size).rgb; m2 += c; s2 += c * c;

c = tex2D(_MainTex, uv + float2(-4., -1.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(0, 3) * src_size).rgb; m2 += c; s2 += c * c;
c = tex2D(_MainTex, uv + float2(-3., -1.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(1, 3) * src_size).rgb; m2 += c; s2 += c * c;
c = tex2D(_MainTex, uv + float2(-2., -1.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(2, 3) * src_size).rgb; m2 += c; s2 += c * c;
c = tex2D(_MainTex, uv + float2(-1., -1.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(3, 3) * src_size).rgb; m2 += c; s2 += c * c;
c = tex2D(_MainTex, uv + float2(0., -1.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(4, 3) * src_size).rgb; m2 += c; s2 += c * c;

c = tex2D(_MainTex, uv + float2(-4., 0.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(0, 4) * src_size).rgb; m2 += c; s2 += c * c;
c = tex2D(_MainTex, uv + float2(-3., 0.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(1, 4) * src_size).rgb; m2 += c; s2 += c * c;
c = tex2D(_MainTex, uv + float2(-2., 0.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(2, 4) * src_size).rgb; m2 += c; s2 += c * c;
c = tex2D(_MainTex, uv + float2(-1., 0.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(3, 4) * src_size).rgb; m2 += c; s2 += c * c;
c = tex2D(_MainTex, uv + float2(0., 0.) * src_size).rgb; m0 += c; s0 += c * c;
c = tex2D(_MainTex, uv + float2(4, 4) * src_size).rgb; m2 += c; s2 += c * c;

float4 ccolor = 0.;

float min_sigma2 = 1e+2;
m0 /= n;
s0 = abs(s0 / n - m0 * m0);


float sigma2 = s0.r + s0.g + s0.b;
if (sigma2 < min_sigma2) {
	min_sigma2 = sigma2;
	ccolor = float4(m0, 1.0);
}


m2 /= n;
s2 = abs(s2 / n - m2 * m2);

sigma2 = s2.r + s2.g + s2.b;
if (sigma2 < min_sigma2) {
	min_sigma2 = sigma2;
	ccolor = float4(m2, 1.0);
}


/*
float4 txt = tex2D(_MainTex, uv);
float4 txt2 = lerp(txt,efx(uv), _LightIntensity);
txt = lerp(txt,txt2,depth);
*/

return ccolor;
}

ENDCG
}

}
}