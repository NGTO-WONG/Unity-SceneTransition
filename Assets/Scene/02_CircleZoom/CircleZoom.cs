using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;
using UnityEngine.SceneManagement;

public class CircleZoom : MonoBehaviour
{
    [SerializeField] private GameObject Area;
    [SerializeField] private GameObject transition;
    // [SerializeField] private Camera PlayerCamera;

    Material _material;
    private Tweener tween;
    private static readonly int Value = Shader.PropertyToID("_Value");
    private static readonly int Center = Shader.PropertyToID("_Center");

    // Start is called before the first frame update
    void Start()
    {
        DontDestroyOnLoad(this);
        DontDestroyOnLoad(transition.transform.parent);
        _material = transition.GetComponent<Image>().material;
        _material.SetFloat(Value, 2);
        Area.GetComponent<Trigger>().TriggerEnterEvent.AddListener(Enter);
        Area.GetComponent<Trigger>().TriggerExitEvent.AddListener(Exit);
        Area.GetComponent<Trigger>().TriggerStayEvent.AddListener(Call);
    }


    private void Exit(GameObject arg0)
    {
        tween = _material.DOFloat(2f, Value, 1f);
    }

    private void Enter(GameObject arg0)
    {
        tween = _material.DOFloat(0.2f, Value, 1f);
    }

    private bool loading = false;
    private async void Call(GameObject arg0)
    {
        var viewportPos = Camera.main.WorldToViewportPoint(arg0.transform.position);
        _material.SetVector(Center, viewportPos);
        
        if (tween != null && !tween.IsPlaying())
        {
            _material.SetFloat(Value, _material.GetFloat(Value) - 0.002f);
            if (_material.GetFloat(Value) <= 0.1f)
            {
                tween = _material.DOFloat(0.0f, Value, 1f);
                tween.SetEase(Ease.InOutBack);
            }
        }
        if (_material.GetFloat(Value)<=0.0001f&& loading==false)
        {
            loading = true;
            SceneLoader.GetInstance().animationComplete = true;
            await SceneLoader.GetInstance().LoadSceneAsync("Scene2");
            await Task.Delay(3000);
            var player = GameObject.FindWithTag("Player");
            var viewportPos2 = Camera.main.WorldToViewportPoint(player.transform.position);
            _material.SetVector(Center, viewportPos2);
            tween = _material.DOFloat(2f, Value, 2f);
        }
    }
        
}