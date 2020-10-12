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
        _WaveAmp_1("WaveAmp_1", float) = 0
        _WaveAmp_2("WaveAmp_2", float) = 0 
        _WaveAmp_3("WaveAmp_3", float) = 0 
        _WaveAmp_4("WaveAmp_4", float) = 0 
        _WaveAmp_5("WaveAmp_5", float) = 0 
        _WaveAmp_6("WaveAmp_6", float) = 0
        _Vector1("Vector 1", Vector) = (0, 0, 0, 0)
        _Vector2("Vector 2", Vector) = (0, 0, 0, 0)
        _Vector3("Vector 3", Vector) = (0, 0, 0, 0)
        _Vector4("Vector 4", Vector) = (0, 0, 0, 0)
        _Vector5("Vector 5", Vector) = (0, 0, 0, 0)
        _Vector6("Vector 6", Vector) = (0, 0, 0, 0)
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

        float _WaveAmp_1, _WaveAmp_2, _WaveAmp_3, _WaveAmp_4, _WaveAmp_5, _WaveAmp_6;
        float4 _Vector1, _Vector2, _Vector3, _Vector4, _Vector5, _Vector6;

        half _Glossiness;
        half _Metallic;
        half _Period;
        half _Speed;
        half _Amplitude;
        fixed4 _Color;
        
        UNITY_INSTANCING_BUFFER_START(Props)

        UNITY_INSTANCING_BUFFER_END(Props)

        half addWaveOscilation(float3 hitPoint, float waveAmp, float3 positionWorld, float3 posObject, float k){
            // Getting the distance from where this wave should start, to the current position
            float _distance = distance(float3(_Vector1.xyz), positionWorld);
            // We can this as the radius, how much is far from the hitPoint, in a circular way
            half value = _Amplitude /2 * sin(-_distance + (_Time.y*_Speed*k));
            return waveAmp*value;
        }

        void vert(inout appdata_full v){
            float3 pos = v.vertex.xyz;
            float3 posWorld = (mul(unity_ObjectToWorld, float4(pos, 1.0))).xyz;
            float k = 2 * UNITY_PI;
            
            // This is the diagonal move of the waves, using the values of x and z
            half value = _Amplitude / 2 * sin(_Time.w * _Speed + ((pos.x+pos.z )*(_Period*k)));
            pos.y += value;

            // This are all the waves oscilations that can be compute by the moment
            pos.y -= addWaveOscilation(_Vector1.xyz, _WaveAmp_1, posWorld, pos, k);
            pos.y -= addWaveOscilation(_Vector2.xyz, _WaveAmp_2, posWorld, pos, k);
            pos.y -= addWaveOscilation(_Vector3.xyz, _WaveAmp_3, posWorld, pos, k);
            pos.y -= addWaveOscilation(_Vector4.xyz, _WaveAmp_4, posWorld, pos, k);
            pos.y -= addWaveOscilation(_Vector5.xyz, _WaveAmp_5, posWorld, pos, k);
            pos.y -= addWaveOscilation(_Vector6.xyz, _WaveAmp_6, posWorld, pos, k);
            
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
