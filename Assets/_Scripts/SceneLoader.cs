using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using DG.Tweening.Core;
using UnityEditorInternal;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneLoader
{
    private static SceneLoader _instance;
    public static SceneLoader GetInstance()
    {
        _instance ??= new SceneLoader();
        return _instance;
    }

    public bool animationComplete=false;

    public async Task LoadSceneAsync(string name)
    {
        var sceneBuffer= SceneManager.LoadSceneAsync(name,LoadSceneMode.Single);
        while (!sceneBuffer.isDone||!animationComplete)
        {
            await Task.Yield();
        }
        sceneBuffer.allowSceneActivation = true;
        animationComplete = false;
    }

}
