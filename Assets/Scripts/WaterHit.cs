using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterHit : MonoBehaviour
{
    private int NumOfHit = 0;
    private const int NumOfWaves = 6;    
    private float MagnitudeDivider = 0.5f;
    public Material Mat;
    private float [] WaveAmp = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f};
    private float __Time = 0.0f;
    private Vector3 HitPos;
    // Start is called before the first frame update
    void Start()
    {
        NumOfHit = 0;
    }

    // Update is called once per frame
    void Update()
    {
        if (__Time > 1.0f) __Time = 0.0f;

        __Time += Time.deltaTime;

        Mat.SetFloat("___TimeSeconds", __Time);

        for (int num = 0; num < NumOfWaves; num++){
            WaveAmp[num] = Mat.GetFloat("_WaveAmp_" + (num+1));
            if (WaveAmp[num] > 0.5){
                Mat.SetFloat("_WaveAmp_"+ (num+1), WaveAmp[num] * .99f);
            }
            else{
                Mat.SetFloat("_WaveAmp_"+ (num+1), 0.0f);
            }
        }

    }

    private void OnCollisionEnter(Collision other) {
        NumOfHit++;
        if (NumOfHit > NumOfWaves){
            NumOfHit = 1;
            WaveAmp[NumOfHit-1] = 0;
        } 
        ContactPoint contact = other.contacts[0];
        Quaternion rot = Quaternion.FromToRotation(Vector3.up, contact.normal);
        HitPos = contact.point;
        Mat.SetFloat("_offsetX" + NumOfHit, HitPos.x);
        Mat.SetFloat("_offsetZ" + NumOfHit, HitPos.z);
        Mat.SetFloat("_WaveAmp_"+ NumOfHit, other.rigidbody.velocity.magnitude *MagnitudeDivider);
    }
}
