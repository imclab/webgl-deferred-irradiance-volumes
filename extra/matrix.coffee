pi = Math.PI
tau = 2*pi
deg = 360/tau
arc = tau/360

window.Mat3 = class Mat3
    constructor: (@data) ->
        @data ?= new Float32Array 9
        @identity()
    
    identity: ->
        d = @data
        d[0]  = 1; d[1]  =0; d[2]  = 0
        d[3]  = 0; d[4]  =1; d[5]  = 0
        d[6]  = 0; d[7]  =0; d[8]  = 1
        return @

    transpose: ->
        d = @data
        a01 = d[1]; a02 = d[2]; a12 = d[5]

        d[1] = d[3]
        d[2] = d[6]
        d[3] = a01
        d[5] = d[7]
        d[6] = a02
        d[7] = a12
        return @
   
    mulVec3: (vec, dst=vec) ->
        @mulVal3 vec.x, vec.y, vec.z, dst
        return dst

    mulVal3: (x, y, z, dst) ->
        dst = dst.data
        d = @data
        dst[0] = d[0]*x + d[3]*y + d[6]*z
        dst[1] = d[1]*x + d[4]*y + d[7]*z
        dst[2] = d[2]*x + d[5]*y + d[8]*z

        return @

    rotatex: (angle) ->
        s = Math.sin angle*arc
        c = Math.cos angle*arc
        return @amul(
             1,  0,  0,
             0,  c,  s,
             0, -s,  c
        )
    
    rotatey: (angle) ->
        s = Math.sin angle*arc
        c = Math.cos angle*arc
        return @amul(
             c,  0, -s,
             0,  1,  0,
             s,  0,  c
        )
    
    rotatez: (angle) ->
        s = Math.sin angle*arc
        c = Math.cos angle*arc
        return @amul(
             c,  s,  0,
            -s,  c,  0,
             0,  0,  1
        )
       
    amul: (
        b00, b10, b20,
        b01, b11, b21,
        b02, b12, b22,
        b03, b13, b23
    ) ->
        a = @data

        a00 = a[0]
        a10 = a[1]
        a20 = a[2]
        
        a01 = a[3]
        a11 = a[4]
        a21 = a[5]
        
        a02 = a[6]
        a12 = a[7]
        a22 = a[8]
        
        a[0]  = a00*b00 + a01*b10 + a02*b20
        a[1]  = a10*b00 + a11*b10 + a12*b20
        a[2]  = a20*b00 + a21*b10 + a22*b20
        
        a[3]  = a00*b01 + a01*b11 + a02*b21
        a[4]  = a10*b01 + a11*b11 + a12*b21
        a[5]  = a20*b01 + a21*b11 + a22*b21
        
        a[6]  = a00*b02 + a01*b12 + a02*b22
        a[7]  = a10*b02 + a11*b12 + a12*b22
        a[8]  = a20*b02 + a21*b12 + a22*b22

        return @

    log: ->
        d = @data
        console.log '%f, %f, %f,\n%f, %f, %f, \n%f, %f, %f, ', d[0], d[1], d[2], d[3], d[4], d[5], d[6], d[7], d[8]

window.Mat4 = class Mat4
    constructor: (@data) ->
        @data ?= new Float32Array 16
        @identity()

    identity: ->
        d = @data
        d[0]  = 1; d[1]  =0; d[2]  = 0; d[3]  = 0
        d[4]  = 0; d[5]  =1; d[6]  = 0; d[7]  = 0
        d[8]  = 0; d[9]  =0; d[10] = 1; d[11] = 0
        d[12] = 0; d[13] =0; d[14] = 0; d[15] = 1
        return @

    zero: ->
        d = @data
        d[0]  = 0; d[1]  =0; d[2]  = 0; d[3]  = 0
        d[4]  = 0; d[5]  =0; d[6]  = 0; d[7]  = 0
        d[8]  = 0; d[9]  =0; d[10] = 0; d[11] = 0
        d[12] = 0; d[13] =0; d[14] = 0; d[15] = 0
        return @

    copy: (dest) ->
        src = @data
        dst = dest.data
        dst[0] = src[0]
        dst[1] = src[1]
        dst[2] = src[2]
        dst[3] = src[3]
        dst[4] = src[4]
        dst[5] = src[5]
        dst[6] = src[6]
        dst[7] = src[7]
        dst[8] = src[8]
        dst[9] = src[9]
        dst[10] = src[10]
        dst[11] = src[11]
        dst[12] = src[12]
        dst[13] = src[13]
        dst[14] = src[14]
        dst[15] = src[15]
        return dest

    toMat3: (dest) ->
        src = @data
        dst = dest.data
        dst[0] = src[0]
        dst[1] = src[1]
        dst[2] = src[2]
        dst[3] = src[4]
        dst[4] = src[5]
        dst[5] = src[6]
        dst[6] = src[8]
        dst[7] = src[9]
        dst[8] = src[10]
        
        return dest

    toMat3Rot: (dest) ->
        dst = dest.data
        src = @data
        a00 = src[0]; a01 = src[1]; a02 = src[2]
        a10 = src[4]; a11 = src[5]; a12 = src[6]
        a20 = src[8]; a21 = src[9]; a22 = src[10]

        b01 = a22 * a11 - a12 * a21
        b11 = -a22 * a10 + a12 * a20
        b21 = a21 * a10 - a11 * a20

        d = a00 * b01 + a01 * b11 + a02 * b21
        id = 1 / d

        dst[0] = b01 * id
        dst[3] = (-a22 * a01 + a02 * a21) * id
        dst[6] = (a12 * a01 - a02 * a11) * id
        dst[1] = b11 * id
        dst[4] = (a22 * a00 - a02 * a20) * id
        dst[7] = (-a12 * a00 + a02 * a10) * id
        dst[2] = b21 * id
        dst[5] = (-a21 * a00 + a01 * a20) * id
        dst[8] = (a11 * a00 - a01 * a10) * id

        return dest

    perspective: (fov, aspect, near, far) ->
        @zero()
        d = @data
        top = near * Math.tan(fov*Math.PI/360)
        right = top*aspect
        left = -right
        bottom = -top

        d[0] = (2*near)/(right-left)
        d[5] = (2*near)/(top-bottom)
        d[8] = (right+left)/(right-left)
        d[9] = (top+bottom)/(top-bottom)
        d[10] = -(far+near)/(far-near)
        d[11] = -1
        d[14] = -(2*far*near)/(far-near)
       
        return @
        
    inversePerspective: (fov, aspect, near, far) ->
        @zero()
        dst = @data
        top = near * Math.tan(fov*Math.PI/360)
        right = top*aspect
        left = -right
        bottom = -top

        dst[0] = (right-left)/(2*near)
        dst[5] = (top-bottom)/(2*near)
        dst[11] = -(far-near)/(2*far*near)
        dst[12] = (right+left)/(2*near)
        dst[13] = (top+bottom)/(2*near)
        dst[14] = -1
        dst[15] = (far+near)/(2*far*near)

        return @
       
    ortho: (near=-1, far=1, top=-1, bottom=1, left=-1, right=1) ->
        rl = right-left
        tb = top - bottom
        fn = far - near

        return @set(
            2/rl,   0,      0,      -(left+right)/rl,
            0,      2/tb,   0,      -(top+bottom)/tb,
            0,      0,      -2/fn,  -(far+near)/fn,
            0,      0,      0,      1,
        )
        
    inverseOrtho: (near=-1, far=1, top=-1, bottom=1, left=-1, right=1) ->
        a = (right-left)/2
        b = (right+left)/2
        c = (top-bottom)/2
        d = (top+bottom)/2
        e = (far-near)/-2
        f = (near+far)/2
        g = 1

        return @set(
            a, 0, 0, b,
            0, c, 0, d,
            0, 0, e, f,
            0, 0, 0, g
        )

    fromRotationTranslation: (quat, vec) ->
        x = quat.x; y = quat.y; z = quat.z; w = quat.w
        x2 = x + x
        y2 = y + y
        z2 = z + z

        xx = x * x2
        xy = x * y2
        xz = x * z2
        yy = y * y2
        yz = y * z2
        zz = z * z2
        wx = w * x2
        wy = w * y2
        wz = w * z2

        dest = @data
       
        ''' 
        dest[0] = 1 - 2.0 * y * y - 2.0 * y * y
        dest[1] = 2 * x * y - 2.0 * w * z
        dest[3] = 2 * x * z + 2.0 * w * y
        
        dest[4] = 2 * x * y + 2.0 * w * z
        dest[5] = 1 - 2.0 * x * x - 2.0 * z * z
        dest[6] = 2 * y * z - 2.0 * w * x

        dest[8] = 2 * x * z - 2.0 * w * y
        dest[9] = 2 * y * z + 2.0 * w * x
        dest[10] = 1 - 2.0 * x * x - 2.0 * y * y
        '''

        '''
        dest[0] = 1 - 2.0 * y * y - 2.0 * y * y
        dest[1] = 2 * x * y + 2.0 * w * z
        dest[2] = 2 * x * z - 2.0 * w * y

        dest[4] = 2 * x * y - 2.0 * w * z
        dest[5] = 1 - 2.0 * x * x - 2.0 * z * z
        dest[6] = 2 * y * z + 2.0 * w * x

        dest[8] = 2 * x * z + 2.0 * w * y
        dest[9] = 2 * y * z - 2.0 * w * x
        dest[10] = 1 - 2.0 * x * x - 2.0 * y * y
        '''

        dest[0] = 1 - (yy + zz)
        dest[1] = xy + wz
        dest[2] = xz - wy
        dest[3] = 0
        dest[4] = xy - wz
        dest[5] = 1 - (xx + zz)
        dest[6] = yz + wx
        dest[7] = 0
        dest[8] = xz + wy
        dest[9] = yz - wx
        dest[10] = 1 - (xx + yy)
        dest[11] = 0
        
        dest[12] = vec.x
        dest[13] = vec.y
        dest[14] = vec.z
        dest[15] = 1
        
        return @
    
    translateVec3: (vec) ->
        return @translateVal3 vec.x, vec.y, vec.z

    translateVal3: (x, y, z) ->
        d = @data
        a00 = d[0]; a01 = d[1]; a02 = d[2]; a03 = d[3]
        a10 = d[4]; a11 = d[5]; a12 = d[6]; a13 = d[7]
        a20 = d[8]; a21 = d[9]; a22 = d[10]; a23 = d[11]

        d[12] = a00 * x + a10 * y + a20 * z + d[12]
        d[13] = a01 * x + a11 * y + a21 * z + d[13]
        d[14] = a02 * x + a12 * y + a22 * z + d[14]
        d[15] = a03 * x + a13 * y + a23 * z + d[15]

        return @

    rotatex: (angle) ->
        d = @data
        rad = tau*(angle/360)
        s = Math.sin rad
        c = Math.cos rad

        a10 = d[4]
        a11 = d[5]
        a12 = d[6]
        a13 = d[7]
        a20 = d[8]
        a21 = d[9]
        a22 = d[10]
        a23 = d[11]

        d[4] = a10 * c + a20 * s
        d[5] = a11 * c + a21 * s
        d[6] = a12 * c + a22 * s
        d[7] = a13 * c + a23 * s

        d[8] = a10 * -s + a20 * c
        d[9] = a11 * -s + a21 * c
        d[10] = a12 * -s + a22 * c
        d[11] = a13 * -s + a23 * c

        return @

    rotatey: (angle) ->
        d = @data
        rad = tau*(angle/360)
        s = Math.sin rad
        c = Math.cos rad

        a00 = d[0]
        a01 = d[1]
        a02 = d[2]
        a03 = d[3]
        a20 = d[8]
        a21 = d[9]
        a22 = d[10]
        a23 = d[11]

        d[0] = a00 * c + a20 * -s
        d[1] = a01 * c + a21 * -s
        d[2] = a02 * c + a22 * -s
        d[3] = a03 * c + a23 * -s

        d[8] = a00 * s + a20 * c
        d[9] = a01 * s + a21 * c
        d[10] = a02 * s + a22 * c
        d[11] = a03 * s + a23 * c

        return @
    
    rotatez: (angle) ->
        d = @data
        rad = tau*(angle/360)
        s = Math.sin rad
        c = Math.cos rad

        a00 = d[0]
        a01 = d[1]
        a02 = d[2]
        a03 = d[3]
        a10 = d[4]
        a11 = d[5]
        a12 = d[6]
        a13 = d[7]

        d[0] = a00 * c + a10 * s
        d[1] = a01 * c + a11 * s
        d[2] = a02 * c + a12 * s
        d[3] = a03 * c + a13 * s
        d[4] = a00 * -s + a10 * c
        d[5] = a01 * -s + a11 * c
        d[6] = a02 * -s + a12 * c
        d[7] = a03 * -s + a13 * c
                 
        return @

    scale: (scalar) ->
        d = @data

        a00 = d[0]; a01 = d[1]; a02 = d[2]; a03 = d[3]
        a10 = d[4]; a11 = d[5]; a12 = d[6]; a13 = d[7]
        a20 = d[8]; a21 = d[9]; a22 = d[10]; a23 = d[11]

        d[0] = a00 * scalar
        d[1] = a01 * scalar
        d[2] = a02 * scalar
        d[3] = a03 * scalar

        d[4] = a10 * scalar
        d[5] = a11 * scalar
        d[6] = a12 * scalar
        d[7] = a13 * scalar

        d[8] = a20 * scalar
        d[9] = a21 * scalar
        d[10] = a22 * scalar
        d[11] = a23 * scalar
        
        return @

    mulMat4: (other, dst=@) ->
        dest = dst.data
        mat = @data
        mat2 = other.data

        a00 = mat[ 0]; a01 = mat[ 1]; a02 = mat[ 2]; a03 = mat[3]
        a10 = mat[ 4]; a11 = mat[ 5]; a12 = mat[ 6]; a13 = mat[7]
        a20 = mat[ 8]; a21 = mat[ 9]; a22 = mat[10]; a23 = mat[11]
        a30 = mat[12]; a31 = mat[13]; a32 = mat[14]; a33 = mat[15]

        b0  = mat2[0]; b1 = mat2[1]; b2 = mat2[2]; b3 = mat2[3]
        dest[0] = b0*a00 + b1*a10 + b2*a20 + b3*a30
        dest[1] = b0*a01 + b1*a11 + b2*a21 + b3*a31
        dest[2] = b0*a02 + b1*a12 + b2*a22 + b3*a32
        dest[3] = b0*a03 + b1*a13 + b2*a23 + b3*a33

        b0 = mat2[4]
        b1 = mat2[5]
        b2 = mat2[6]
        b3 = mat2[7]
        dest[4] = b0*a00 + b1*a10 + b2*a20 + b3*a30
        dest[5] = b0*a01 + b1*a11 + b2*a21 + b3*a31
        dest[6] = b0*a02 + b1*a12 + b2*a22 + b3*a32
        dest[7] = b0*a03 + b1*a13 + b2*a23 + b3*a33

        b0 = mat2[8]
        b1 = mat2[9]
        b2 = mat2[10]
        b3 = mat2[11]
        dest[8] = b0*a00 + b1*a10 + b2*a20 + b3*a30
        dest[9] = b0*a01 + b1*a11 + b2*a21 + b3*a31
        dest[10] = b0*a02 + b1*a12 + b2*a22 + b3*a32
        dest[11] = b0*a03 + b1*a13 + b2*a23 + b3*a33

        b0 = mat2[12]
        b1 = mat2[13]
        b2 = mat2[14]
        b3 = mat2[15]
        dest[12] = b0*a00 + b1*a10 + b2*a20 + b3*a30
        dest[13] = b0*a01 + b1*a11 + b2*a21 + b3*a31
        dest[14] = b0*a02 + b1*a12 + b2*a22 + b3*a32
        dest[15] = b0*a03 + b1*a13 + b2*a23 + b3*a33

        return dst
   
    mulVec3: (vec, dst=vec) ->
        return @mulVal3 vec.x, vec.y, vec.z, dst

    mulVal3: (x, y, z, dst) ->
        dst = dst.data
        d = @data
        dst[0] = d[0]*x + d[4]*y + d[8] *z
        dst[1] = d[1]*x + d[5]*y + d[9] *z
        dst[2] = d[2]*x + d[6]*y + d[10]*z

        return dst

    mulVec4: (vec, dst) ->
        dst ?= vec
        return @mulVal4 vec.x, vec.y, vec.z, vec.w, dst

    mulVal4: (x, y, z, w, dst) ->
        dst = dst.data
        d = @data
        dst[0] = d[0]*x + d[4]*y + d[8] *z + d[12]*w
        dst[1] = d[1]*x + d[5]*y + d[9] *z + d[13]*w
        dst[2] = d[2]*x + d[6]*y + d[10]*z + d[14]*w
        dst[3] = d[3]*x + d[7]*y + d[11]*z + d[15]*w

        return dst

    invert: (dst=@) ->
        mat = @data
        dest = dst.data

        a00 = mat[0]; a01 = mat[1]; a02 = mat[2]; a03 = mat[3]
        a10 = mat[4]; a11 = mat[5]; a12 = mat[6]; a13 = mat[7]
        a20 = mat[8]; a21 = mat[9]; a22 = mat[10]; a23 = mat[11]
        a30 = mat[12]; a31 = mat[13]; a32 = mat[14]; a33 = mat[15]

        b00 = a00 * a11 - a01 * a10
        b01 = a00 * a12 - a02 * a10
        b02 = a00 * a13 - a03 * a10
        b03 = a01 * a12 - a02 * a11
        b04 = a01 * a13 - a03 * a11
        b05 = a02 * a13 - a03 * a12
        b06 = a20 * a31 - a21 * a30
        b07 = a20 * a32 - a22 * a30
        b08 = a20 * a33 - a23 * a30
        b09 = a21 * a32 - a22 * a31
        b10 = a21 * a33 - a23 * a31
        b11 = a22 * a33 - a23 * a32

        d = (b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06)
            
        if d==0 then return
        invDet = 1 / d

        dest[0] = (a11 * b11 - a12 * b10 + a13 * b09) * invDet
        dest[1] = (-a01 * b11 + a02 * b10 - a03 * b09) * invDet
        dest[2] = (a31 * b05 - a32 * b04 + a33 * b03) * invDet
        dest[3] = (-a21 * b05 + a22 * b04 - a23 * b03) * invDet
        dest[4] = (-a10 * b11 + a12 * b08 - a13 * b07) * invDet
        dest[5] = (a00 * b11 - a02 * b08 + a03 * b07) * invDet
        dest[6] = (-a30 * b05 + a32 * b02 - a33 * b01) * invDet
        dest[7] = (a20 * b05 - a22 * b02 + a23 * b01) * invDet
        dest[8] = (a10 * b10 - a11 * b08 + a13 * b06) * invDet
        dest[9] = (-a00 * b10 + a01 * b08 - a03 * b06) * invDet
        dest[10] = (a30 * b04 - a31 * b02 + a33 * b00) * invDet
        dest[11] = (-a20 * b04 + a21 * b02 - a23 * b00) * invDet
        dest[12] = (-a10 * b09 + a11 * b07 - a12 * b06) * invDet
        dest[13] = (a00 * b09 - a01 * b07 + a02 * b06) * invDet
        dest[14] = (-a30 * b03 + a31 * b01 - a32 * b00) * invDet
        dest[15] = (a20 * b03 - a21 * b01 + a22 * b00) * invDet

        return dst

    set: (
        a00, a10, a20, a30,
        a01, a11, a21, a31,
        a02, a12, a22, a32,
        a03, a13, a23, a33,
    ) ->
        d = @data
        d[0]=a00; d[4]=a10; d[8]=a20; d[12]=a30
        d[1]=a01; d[5]=a11; d[9]=a21; d[13]=a31
        d[2]=a02; d[6]=a12; d[10]=a22; d[14]=a32
        d[3]=a03; d[7]=a13; d[11]=a23; d[15]=a33

        return @
