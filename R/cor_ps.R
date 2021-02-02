resp.hand.ks <- data.frame(tests = c("mu", "sigma", "tau", "hr", "fa", "de"), 
                           ps = c(0.004443, 0.06207, 0.0002403, 0.0006095, 0.7159, 0.02143))
resp.hand.ks$cor.ps <- p.adjust(resp.hand.ks$ps, method = "bonf")


mu <- data.frame(tests = c("group", "distractors", "d:pres,t:AF", "ctrl:AF", "adhd:AF", "drAF:CvA"), 
                 ps = c(0.043039, 0.004070, 0.0029, 0.00009, 0.051, 0.07493))
mu$cor.ps <- p.adjust(mu$ps, method = "holm")
mu$cor.ps

sigma <- data.frame(tests = c("group", "d:pres,t:AF", "ctrl:AF", "adhd:AF", "drAF:CvA"), 
                    ps = c(0.04353524, 0.0028, 0.0029, 0.8, 0.07392))
sigma$cor.ps <- p.adjust(sigma$ps, method = "holm")
sigma$cor.ps

tau <- data.frame(tests = c("d:pres,t:AF", "ctrl:AF", "adhd:AF"), 
                    ps = c(0.0304, 0.0301, 0.3622))
tau$cor.ps <- p.adjust(tau$ps, method = "holm")
tau$cor.ps

