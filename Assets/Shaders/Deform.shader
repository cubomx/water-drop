Shader "Unlit/Deform"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Size ("Size", float) = 1
        _IsConstSize ("Keep Size Constant", float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Size;
            float _IsConstSize;

            v2f vert (appdata v)
            {
                v2f o;

                float3 pos = mul(UNITY_MATRIX_M ,v.vertex);
                float dist = length(pos - _WorldSpaceCameraPos);

                // Get the view matrix to perfom the affine transformation

                float4x4 view = UNITY_MATRIX_MV ;

                // Fill the matrix

                // First colunm.
                view._m00 = 1.0f;
                view._m10 = 0.0f;
                view._m20 = 0.0f;
 
                // Second colunm.
                view._m01 = 0.0f;
                view._m11 = 1.0f;
                view._m21 = 0.0f;
 
                // Thrid colunm.
                view._m02 = 0.0f;
                view._m12 = 0.0f;
                view._m22 = 1.0f;
 
                if(_IsConstSize > 0)
                    v.vertex.w /= dist;

                // Change the values to perfom scaling

                v.vertex.w /= (_Size * 0.1);
 
                o.vertex = mul(UNITY_MATRIX_P, mul(view, v.vertex ) );


                //o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
