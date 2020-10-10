using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class WaterDrop : MonoBehaviour
{
    public float DecreaseIndex;
    public string TagSurface;
    public Material Material;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnCollisionEnter(Collision other) {
        if (other.gameObject.tag == TagSurface){
            Debug.Log("it hit");
            float actualSize = Material.GetFloat("_Size");
            if (actualSize < 0.2f){
                Debug.Log("bajo");
            }
            else{
                Material.SetFloat("_Size", actualSize * DecreaseIndex);
            }
            
        }
    }
}
