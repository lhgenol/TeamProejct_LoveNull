﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerManager : Singleton<PlayerManager>
{
    public Player Player { get; set; } // private set을 사용해서 외부에서 직접 수정 불가능하도록 설정
    public PlayerController controller;
    public Customizing customizing;
    protected override void Awake()
    {
        base.Awake();
    }


    public void SetPlayer(Player player)
    {
        Player = player; // Player 설정 함수 추가
    }
}
