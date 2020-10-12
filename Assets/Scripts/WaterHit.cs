using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterHit : MonoBehaviour
{
    private int NumOfHit = 0;
    private const int NumOfWaves = 6;    
    private float Decreaser = 0.3f;
    public Material Mat;
    private float [] WaveAmp = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f};
    private Vector3 HitPos;
    // Start is called before the first frame update
    void Start()
    {
        NumOfHit = 0;
    }

    // Update is called once per frame
    void Update()
    {
        // This for cycle, is for reducing the height of the wave
        for (int num = 0; num < NumOfWaves; num++){
            WaveAmp[num] = Mat.GetFloat("_WaveAmp_" + (num+1));
            if (WaveAmp[num] > 0.01f){
                Mat.SetFloat("_WaveAmp_"+ (num+1), WaveAmp[num] * .99f);
            }
            else{
                Mat.SetFloat("_WaveAmp_"+ (num+1), 0.0f);
            }
        }
    }

    private void OnCollisionEnter(Collision other) {
        NumOfHit++;
        // Moving through the array of waves
        if (NumOfHit > NumOfWaves){
            NumOfHit = 1;
            WaveAmp[NumOfHit-1] = 0;
        } 
        // Getting the point where it hits
        ContactPoint contact = other.contacts[0];
        Quaternion rot = Quaternion.FromToRotation(Vector3.up, contact.normal);
        HitPos = contact.point;
        // Sending the hit point to the shader
        HitPos.y = 0.0f;
        Mat.SetVector("_Vector" + NumOfHit, HitPos);
        Mat.SetFloat("_WaveAmp_"+ NumOfHit, other.rigidbody.velocity.magnitude *Decreaser);
    }
}
