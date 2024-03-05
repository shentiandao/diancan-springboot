package com.qcl.bean;

import javax.persistence.*;
import java.util.Date;
import lombok.Data;

@Entity
@Data
public class LoginHistory {
    @Id
    @GeneratedValue
    private Integer id;
    private String username;
    private String role;
    private Date loginTime;
    // getters and setters
}
