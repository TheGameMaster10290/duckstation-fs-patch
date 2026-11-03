.class public final Lcom/github/stenzek/duckstation/FrontendResume;
.super Ljava/lang/Object;
.source "FrontendResume.java"


# static fields
.field private static final FIND_FLAGS:I = 0x15

.field private static final STATE_NAME:Ljava/util/regex/Pattern;

.field public static report:Ljava/lang/String;

.field public static summary:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .registers 1

    const-string v0, "^.+_([0-9]+|resume)\\.sav$"

    .line 17
    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v0

    sput-object v0, Lcom/github/stenzek/duckstation/FrontendResume;->STATE_NAME:Ljava/util/regex/Pattern;

    const-string v0, ""

    .line 22
    sput-object v0, Lcom/github/stenzek/duckstation/FrontendResume;->report:Ljava/lang/String;

    .line 23
    sput-object v0, Lcom/github/stenzek/duckstation/FrontendResume;->summary:Ljava/lang/String;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 25
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static baseName(Ljava/lang/String;)Ljava/lang/String;
    .registers 3

    .line 30
    invoke-static {p0}, Landroid/net/Uri;->decode(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    const/16 v0, 0x2f

    .line 31
    invoke-virtual {p0, v0}, Ljava/lang/String;->lastIndexOf(I)I

    move-result v0

    const/16 v1, 0x3a

    invoke-virtual {p0, v1}, Ljava/lang/String;->lastIndexOf(I)I

    move-result v1

    invoke-static {v0, v1}, Ljava/lang/Math;->max(II)I

    move-result v0

    add-int/lit8 v0, v0, 0x1

    .line 32
    invoke-virtual {p0, v0}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static find(Ljava/lang/String;)Ljava/lang/String;
    .registers 18

    move-object/from16 v1, p0

    const-string v2, "  "

    .line 36
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, ""

    .line 37
    sput-object v0, Lcom/github/stenzek/duckstation/FrontendResume;->report:Ljava/lang/String;

    .line 38
    sput-object v0, Lcom/github/stenzek/duckstation/FrontendResume;->summary:Ljava/lang/String;

    const/4 v4, 0x0

    if-eqz v1, :cond_164

    .line 39
    invoke-virtual/range {p0 .. p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_1a

    goto/16 :goto_164

    .line 43
    :cond_1a
    invoke-static/range {p0 .. p0}, Lcom/github/stenzek/duckstation/FrontendResume;->baseName(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    const-string v0, "game: "

    .line 44
    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "\nsave state folder: "

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 45
    invoke-static {}, Lcom/github/stenzek/duckstation/NativeLibrary;->getSaveStateDirectory()Ljava/lang/String;

    move-result-object v0

    .line 46
    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v6, 0xa

    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    if-nez v0, :cond_44

    const-string v0, "save state folder unknown"

    .line 48
    sput-object v0, Lcom/github/stenzek/duckstation/FrontendResume;->summary:Ljava/lang/String;

    .line 49
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/github/stenzek/duckstation/FrontendResume;->report:Ljava/lang/String;

    return-object v4

    :cond_44
    const/16 v7, 0x15

    .line 52
    invoke-static {v0, v7}, Lcom/github/stenzek/duckstation/FileHelper;->findFiles(Ljava/lang/String;I)[Lcom/github/stenzek/duckstation/FileHelper$FindResult;

    move-result-object v7

    if-nez v7, :cond_68

    const-string v1, "folder is empty or unreadable\n"

    .line 54
    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 55
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "no save states in "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/github/stenzek/duckstation/FrontendResume;->summary:Ljava/lang/String;

    .line 56
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/github/stenzek/duckstation/FrontendResume;->report:Ljava/lang/String;

    return-object v4

    .line 64
    :cond_68
    array-length v8, v7

    const-wide/16 v10, 0x0

    move-object v13, v4

    const/4 v0, 0x0

    const/4 v12, 0x0

    const/4 v14, 0x0

    :goto_6f
    if-ge v12, v8, :cond_11e

    aget-object v15, v7, v12

    if-eqz v15, :cond_115

    .line 65
    iget-object v9, v15, Lcom/github/stenzek/duckstation/FileHelper$FindResult;->name:Ljava/lang/String;

    if-eqz v9, :cond_115

    iget v9, v15, Lcom/github/stenzek/duckstation/FileHelper$FindResult;->flags:I

    const/16 v16, 0x1

    and-int/lit8 v9, v9, 0x1

    if-eqz v9, :cond_83

    goto/16 :goto_115

    .line 68
    :cond_83
    sget-object v9, Lcom/github/stenzek/duckstation/FrontendResume;->STATE_NAME:Ljava/util/regex/Pattern;

    iget-object v4, v15, Lcom/github/stenzek/duckstation/FileHelper$FindResult;->name:Ljava/lang/String;

    invoke-static {v4}, Lcom/github/stenzek/duckstation/FileHelper;->getFileNameForPath(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v9, v4}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v4

    invoke-virtual {v4}, Ljava/util/regex/Matcher;->matches()Z

    move-result v4

    if-nez v4, :cond_97

    goto/16 :goto_115

    :cond_97
    add-int/lit8 v4, v0, 0x1

    .line 74
    :try_start_99
    iget-object v0, v15, Lcom/github/stenzek/duckstation/FileHelper$FindResult;->name:Ljava/lang/String;

    invoke-static {v0}, Lcom/github/stenzek/duckstation/NativeLibrary;->getSaveStateInfoForPath(Ljava/lang/String;)Lcom/github/stenzek/duckstation/SaveStateInfo;

    move-result-object v0

    if-eqz v0, :cond_a6

    .line 76
    invoke-virtual {v0}, Lcom/github/stenzek/duckstation/SaveStateInfo;->getGamePath()Ljava/lang/String;

    move-result-object v0
    :try_end_a5
    .catchall {:try_start_99 .. :try_end_a5} :catchall_fe

    goto :goto_a7

    :cond_a6
    const/4 v0, 0x0

    .line 82
    :goto_a7
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-nez v9, :cond_bc

    if-eqz v0, :cond_ba

    .line 83
    invoke-static {v0}, Lcom/github/stenzek/duckstation/FrontendResume;->baseName(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_ba

    goto :goto_bc

    :cond_ba
    const/16 v16, 0x0

    :cond_bc
    :goto_bc
    if-eqz v16, :cond_c1

    const-string v6, "  MATCH "

    goto :goto_c2

    :cond_c1
    move-object v6, v2

    .line 84
    :goto_c2
    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v6, v15, Lcom/github/stenzek/duckstation/FileHelper$FindResult;->name:Ljava/lang/String;

    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, " -> "

    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " @"

    .line 85
    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-wide v0, v15, Lcom/github/stenzek/duckstation/FileHelper$FindResult;->modifiedTime:J

    invoke-virtual {v3, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const/16 v1, 0xa

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    if-nez v16, :cond_e4

    goto :goto_114

    :cond_e4
    if-eqz v13, :cond_f6

    .line 90
    iget-wide v0, v15, Lcom/github/stenzek/duckstation/FileHelper$FindResult;->modifiedTime:J

    cmp-long v6, v0, v10

    if-gtz v6, :cond_f6

    iget-wide v0, v15, Lcom/github/stenzek/duckstation/FileHelper$FindResult;->modifiedTime:J

    cmp-long v6, v0, v10

    if-nez v6, :cond_114

    if-eqz v9, :cond_114

    if-nez v14, :cond_114

    .line 92
    :cond_f6
    iget-object v13, v15, Lcom/github/stenzek/duckstation/FileHelper$FindResult;->name:Ljava/lang/String;

    .line 93
    iget-wide v0, v15, Lcom/github/stenzek/duckstation/FileHelper$FindResult;->modifiedTime:J

    move-wide v10, v0

    move v0, v4

    move v14, v9

    goto :goto_115

    :catchall_fe
    move-exception v0

    .line 79
    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, v15, Lcom/github/stenzek/duckstation/FileHelper$FindResult;->name:Ljava/lang/String;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ": header error "

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const/16 v1, 0xa

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    :cond_114
    :goto_114
    move v0, v4

    :cond_115
    :goto_115
    add-int/lit8 v12, v12, 0x1

    const/4 v4, 0x0

    move-object/from16 v1, p0

    const/16 v6, 0xa

    goto/16 :goto_6f

    :cond_11e
    const-string v1, "chosen: "

    .line 97
    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0xa

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    if-eqz v13, :cond_140

    .line 98
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "loading "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {v13}, Lcom/github/stenzek/duckstation/FileHelper;->getFileNameForPath(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_15b

    .line 99
    :cond_140
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "no save state for "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " ("

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " states checked)"

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    :goto_15b
    sput-object v0, Lcom/github/stenzek/duckstation/FrontendResume;->summary:Ljava/lang/String;

    .line 100
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/github/stenzek/duckstation/FrontendResume;->report:Ljava/lang/String;

    return-object v13

    :cond_164
    :goto_164
    const-string v0, "no game path"

    .line 40
    sput-object v0, Lcom/github/stenzek/duckstation/FrontendResume;->summary:Ljava/lang/String;

    const/4 v1, 0x0

    return-object v1
.end method
