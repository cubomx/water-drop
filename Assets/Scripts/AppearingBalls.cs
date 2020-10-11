using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AppearingBalls : MonoBehaviour
{
    public GameObject Go;
    private bool Respawn;

    public Vector3 InitialPos;

    private bool Created = false;

    private float _Time = 0.0f;

    private GameObject ObjOnScene;

    public Material DropMat;


    // Start is called before the first frame update
    void Start()
    {
        Respawn = false;
    }

    // Update is called once per frame
    void Update()
    {
        if (!Created){
            ObjOnScene = Instantiate(Go, InitialPos, Quaternion.identity);
            Created = true;
        }
        else{
            
            if (DropMat.GetFloat("_Size") < .2f){
                Destroy(ObjOnScene);
                _Time = 0.0f;
                Respawn = true;
                DropMat.SetFloat("_Size", 1.0f);
            }
            if (Respawn){
                _Time +=  Time.deltaTime;
                if (_Time > 2.0f){
                    Created = false;
                    Respawn = false;
                }
            }
            
        }
    }
}
