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
        Material.SetFloat("_Size", 0.5f);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnCollisionEnter(Collision other) {
        // Detecting if it collides with the water surface
        if (other.gameObject.tag == TagSurface){
            Debug.Log("it hit");
            float actualSize = Material.GetFloat("_Size");
            // Then, decrease the size of the wate drop depending of its actual size
            if (actualSize > 0.1f){
                Material.SetFloat("_Size", actualSize * DecreaseIndex);
            }   
        }
    }
}
