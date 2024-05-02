# 🔙[OpenGL](/docs/opengl/)

## 三维变换transform
三维转换很常用，包含：平移 缩放 旋转  

通过使用glm库 来简化这个封装  
#include "glm/gtx/transform.hpp"  


## 三维转换类Transform
- 基本要素：
```
	glm::vec3 pos;
    glm::vec3 rot;
    glm::vec3 scale;

    glm::mat4 Transform::GetModel() const
    {
        glm::mat4 matPos = glm::translate(pos);
        glm::mat4 matScale = glm::scale(scale);
        glm::mat4 matRotX = glm::rotate(rot.x, glm::vec3(1.0, 0.0, 0.0));
        glm::mat4 matRotY = glm::rotate(rot.y, glm::vec3(0.0, 1.0, 0.0));
        glm::mat4 matRotZ = glm::rotate(rot.z, glm::vec3(0.0, 0.0, 1.0));
        glm::mat4 matRot = matRotX * matRotY * matRotZ;

        return matPos * matScale * matRot;
    }
```
分别存放：位置 旋转 缩放  
渲染前获取组合后的矩阵：偏移 x 缩放 x 旋转  从右到左 按opengl列主序的规则  

若把该Transform当作某个物体的转换  
则使用方法：  
```
	Transform transform;
    transform.GetPos()->x = sinCounter;
    transform.GetRot()->z = counter * 50;
    transform.SetScale(glm::vec3(cosCounter, cosCounter, cosCounter));

    shader.Update(transform, camera);
```

怎么传给shader？  
```
	glm::mat4 model = transform.GetModel();
	glUniformMatrix4fv(_uniforms[TRANSFORM_U], 1, GL_FALSE, &model[0][0]);
```

shader中的使用：
```
	gl_Position = transform * vec4(position, 1.0);
```





