using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AppearingBalls : MonoBehaviour
{
    public GameObject go;
    public float respawn;

    public Vector3 initialPos;

    private bool created = false;

    private float time = 0.0f;

    private GameObject objOnScene;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (!created){
            objOnScene = Instantiate(go, initialPos, Quaternion.identity);
            created = true;
        }
        else{
            time +=  Time.deltaTime;
            if (time > 10.0f){
                Destroy(objOnScene);
            }
        }
    }
}
