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

    private SphereCollider _SphereCollider;

    private float TimeToDissapear;


    // Start is called before the first frame update
    void Start()
    {
        Respawn = false;
        TimeToDissapear = 0.0f;
    }

    // Update is called once per frame
    void Update()
    {
        if (!Created){
            // creating a new water drop in the initial position
            ObjOnScene = Instantiate(Go, InitialPos, Quaternion.identity);
            // getting collider for decreasing its radius when the sphere gets smaller
            _SphereCollider = ObjOnScene.GetComponent<SphereCollider>();
            Created = true;
        }
        else{
            
            if (DropMat.GetFloat("_Size") < .1f){
                TimeToDissapear += Time.deltaTime;
                // letting some time to make the water drop dissapear
                if (TimeToDissapear > 0.1f){
                    Destroy(ObjOnScene);
                    _Time = 0.0f;
                    _Time +=  Time.deltaTime;
                    Respawn = true;

                    DropMat.SetFloat("_Size", 1.0f); // return to its initial value
                }
                
            }
            // when water drop its gone, program will wait to make it appear another on
            if (Respawn){
                _Time +=  Time.deltaTime;
                if (_Time > 2.0f){
                    Created = false;
                    Respawn = false;
                    TimeToDissapear = 0.0f;
                }
            }
            else{
                // reducing the size of the collider depending the size of the sphere
                _SphereCollider.radius = .5f * DropMat.GetFloat("_Size");
            }
            
        }
    }
}
