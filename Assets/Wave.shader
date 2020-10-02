Shader "Custom/Wave"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Period ("Period", Range(1, 6)) = 4
        _Speed("Speed", Range(0, 4)) = 1
        _Amplitude("Amplitude", Range(-2, 2)) = 0.01
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            fixed4 _Time;
        };

        half _Glossiness;
        half _Metallic;
        half _Period;
        half _Speed;
        half _Amplitude;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)


        void vert(inout appdata_full v){
            float PI = 3.14159;
            float3 pos = v.vertex.xyz;
            pos = (mul(unity_ObjectToWorld, float4(pos, 1.0))).xyz;
            float k = 2 * UNITY_PI / 10;
            pos.y += _Amplitude * sin((_Time.y * _Speed) + (pos.x * (_Period * 2 * PI)));
            
            pos = (mul(unity_WorldToObject, float4(pos, 1.0))).xyz;
            v.vertex.xyz = pos;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;

            
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
