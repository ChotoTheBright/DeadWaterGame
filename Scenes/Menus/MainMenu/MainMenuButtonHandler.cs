using Godot;
using System;

public partial class MainMenuButtonHandler : Node
{
    public void OnStartPressed()
    {
        SceneManager.ChangeSceneForward("res://Scenes/Game/level1.tscn", this); //res://Scenes/Game/GameScene.tscn
    }
    public void OnSettingsPressed()
    {
        SceneManager.ChangeSceneForward("res://Scenes/Menus/SettingMenus/ChooseSettingsMenu/ChooseSettingsMenuScene.tscn", this);
    }
    public void OnQuitPressed()
    {
        GetTree().Quit();
    }
}
