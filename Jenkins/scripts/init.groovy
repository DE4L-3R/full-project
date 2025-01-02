import jenkins.model.*
import hudson.security.*
import jenkins.security.s2m.AdminWhitelistRule

def instance = Jenkins.getInstance()

// CSRF 보호 비활성화 (개발 환경용)
instance.setCrumbIssuer(null)

// 기본 보안 설정
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)

// 기본 플러그인 설치
def pm = instance.getPluginManager()
def uc = instance.getUpdateCenter()
def plugins = [
    "git",
    "workflow-aggregator",
    "kubernetes",
    "configuration-as-code",
    "job-dsl"
]

plugins.each { plugin ->
    if (!pm.getPlugin(plugin)) {
        def installFuture = uc.getPlugin(plugin).deploy()
        installFuture.get()
    }
}

instance.save()
