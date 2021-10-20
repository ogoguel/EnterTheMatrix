## Behind The Matrix  Shader Source Code

### Shader code used in boths matrix video
#### Shader Library
##### XPARCommon.ginc 
Useful functions to be to be reused in shader

* Depth to Distance 
* Depth to World Position 
* UNITY_EDITOR emulation : when the #define is used, a rendertexture can be used to simulate a depth camera. 
In that case, the texture contains the depth (and not the distance as it is for a physical camera) but the library does the conversion between the two modes
 
##### PortalCommon.ginc
Specific functions to display a portal in the scene

* PORTALDOOR : outside view
* PORTALWALL : inside view
* _Portal : rendered texture of the portal frame

#### Shaders

<table border="0" style="width:100%">
<tr>
<td >
<b>Depth Buffer Shader</b>
</td>
<td >
<b>Worlspace Shader</b>
</td>
<td >
<b>Triplanar Shader</b>
</td>
</tr>
<tr>
<td>
Display  the depth buffer
</td>
<td>
Display a grid on top of the mesh in the worldspace coordinate
</td>
<td>
Display a triplanar texture on top of the mesh, with portal support
</td>
</tr>
<tr>
<td >
	<img src="DepthBuffer.png?raw=true" width="100%" height="auto" />
</td>
<td> 
	<img src="WorldSpace.png?raw=true" width="100%" height="auto" />
</td>
<td>
	<img src="TriPlanar.png?raw=true" width="100%" height="auto" />
</td>
</tr>
</table>

### Sample Unity Project

Sample Unity project using the Universal Render Pipeline and ARFoundation.
(Using a light version of the Triplanar shader)
  
<table border="0" style="width:33%">
<tr>
<td >
<b>TriPlanar Shader</b>
</td>
</tr>
<tr>
<td >
    <img src="TriPlanarSample.png?raw=true" width="100%" height="auto" />
</td>
</tr>
</table>

### Next:
More shaders & samples to come

### References:

* Original Linkedin post : [https://www.linkedin.com/feed/update/urn:li:activity:6741697110854397953/](https://www.linkedin.com/feed/update/urn:li:activity:6741697110854397953/)

* LidarToe App: [http://www.lidarexperience.com/](http://www.lidarexperience.com/)

