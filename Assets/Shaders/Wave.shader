Shader "Custom/Wave"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,0.1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Period ("Period", Range(0, 20)) = 1
        _Speed("Speed", Range(0, 8)) = 1
        _Amplitude("Amplitude", Range(-2, 2)) = .32
        _Started("Started", Int) = 0
        _WaveAmp_1("WaveAmp_1", float) = 0
        _WaveAmp_2("WaveAmp_2", float) = 0 
        _WaveAmp_3("WaveAmp_3", float) = 0 
        _WaveAmp_4("WaveAmp_4", float) = 0 
        _WaveAmp_5("WaveAmp_5", float) = 0 
        _WaveAmp_6("WaveAmp_6", float) = 0
        _offsetX1("offset X1", float) = 0 
        _offsetX2("offset X2", float) = 0
        _offsetX3("offset X3", float) = 0
        _offsetX4("offset X4", float) = 0
        _offsetX5("offset X5", float) = 0
        _offsetX6("offset X6", float) = 0
        _offsetZ1("offset Z1", float) = 0
        _offsetZ2("offset Z2", float) = 0 
        _offsetZ3("offset Z3", float) = 0 
        _offsetZ4("offset Z4", float) = 0 
        _offsetZ5("offset Z5", float) = 0 
        _offsetZ6("offset Z6", float) = 0 
        _TimeSeconds("Time Secs", float) = 0     
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

        float _WaveAmp_1, _WaveAmp_2, _WaveAmp_3, _WaveAmp_4, _WaveAmp_5, _WaveAmp_6;
        float _offsetX1, _offsetZ1, _offsetX2, _offsetZ2, _offsetX3, _offsetZ3, _offsetX4, _offsetZ4, _offsetX5, _offsetZ5, _offsetX6, _offsetZ6;

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
        float _TimeSeconds;
        int _Started;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)


        void vert(inout appdata_full v){
            float3 pos = v.vertex.xyz;
            float3 posWorld = (mul(unity_ObjectToWorld, float4(pos, 1.0))).xyz;
            float k = 2 * UNITY_PI;
            
            half value = _Amplitude / 2 * sin(_Time.w * _Speed + ((pos.x+pos.z )*(_Period*k)));
            pos.y += value;
            //pos = (mul(unity_WorldToObject, float4(pos, 1.0))).xyz;
            float d1 = distance(float3(_offsetX1, 0, _offsetZ1), posWorld);
            half value1 = _Amplitude /2 * sin(-d1 + (_Time.y*_Speed*k*2));
            float d2 = distance(float3(_offsetX2, 0, _offsetZ2), posWorld);
            half value2 = _Amplitude /2 * sin(-d2 + (_Time.y*_Speed*k*2));
            float d3 = distance(float3(_offsetX3, 0, _offsetZ3), posWorld);
            half value3 = _Amplitude /2 * sin(-d3+ (_Time.y*_Speed*k*2));
            float d4 = distance(float3(_offsetX4, 0, _offsetZ4), posWorld);
            half value4 = _Amplitude /2  * sin(-d4 + (_Time.y*_Speed*k*2));
            float d5 = distance(float3(_offsetX5, 0, _offsetZ5), posWorld);
            half value5 = _Amplitude/2  * sin(-d5+ (_Time.y*_Speed*k*2));
            float d6 = distance(float3(_offsetX6, 0, _offsetZ6), posWorld);
            half value6 = _Amplitude /2  * sin(-d6 + (_Time.y*_Speed*k*2));
            pos.y += value1*(_WaveAmp_1);
            pos.y += value2*(_WaveAmp_2);
            pos.y += value3*(_WaveAmp_3);
            pos.y += value4*(_WaveAmp_4);
            pos.y += value5*(_WaveAmp_5);
            pos.y += value6*(_WaveAmp_6);

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
