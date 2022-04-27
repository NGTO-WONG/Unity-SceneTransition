using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Trigger : MonoBehaviour
{

    public UnityEvent<GameObject> TriggerStayEvent; 
    public UnityEvent<GameObject> TriggerEnterEvent; 
    public UnityEvent<GameObject> TriggerExitEvent; 
     void OnTriggerStay(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            TriggerStayEvent.Invoke(other.gameObject);        
        }
    } 
     void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            TriggerEnterEvent.Invoke(other.gameObject);        
        }
    }
     void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            TriggerExitEvent.Invoke(other.gameObject);        
        }
    }
}
